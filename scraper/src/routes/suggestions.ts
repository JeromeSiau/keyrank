import { Router, Request, Response } from 'express';
import gplay from 'google-play-scraper';

const router = Router();

interface SuggestQuery {
  country?: string;
  lang?: string;
}

// Get autocomplete suggestions for a term
router.get('/term/:term', async (req: Request, res: Response) => {
  try {
    const { term } = req.params;
    const { country = 'us', lang = 'en' } = req.query as unknown as SuggestQuery;

    if (!term || term.length < 2) {
      res.status(400).json({ error: 'Term must be at least 2 characters' });
      return;
    }

    const suggestions = await gplay.suggest({
      term,
      country,
      lang,
    });

    res.json({ suggestions });
  } catch (error) {
    console.error('Suggest error:', error);
    res.status(500).json({ error: 'Failed to get suggestions' });
  }
});

// Get keyword suggestions for an app (like iOS KeywordDiscoveryService)
router.get('/app/:appId', async (req: Request, res: Response) => {
  try {
    const { appId } = req.params;
    const { country = 'us', lang = 'en', limit = '50' } = req.query;
    const maxLimit = Math.min(Number(limit), 100);

    // Get app details first
    let appData: any;
    try {
      appData = await gplay.app({
        appId,
        country: country as string,
        lang: lang as string,
      });
    } catch (error) {
      res.status(404).json({ error: 'App not found' });
      return;
    }

    // Extract seed terms from app name and description
    const seeds = extractSeedTerms(appData.title, appData.description || '');

    // Get suggestions for each seed
    const allSuggestions = new Map<string, string>();

    for (const seed of seeds) {
      try {
        const hints = await gplay.suggest({
          term: seed.term,
          country: country as string,
          lang: lang as string,
        });

        for (const hint of hints) {
          if (!allSuggestions.has(hint)) {
            allSuggestions.set(hint, seed.source);
          }
        }

        // Rate limiting
        await new Promise((resolve) => setTimeout(resolve, 100));
      } catch (error) {
        console.error(`Error getting suggestions for "${seed.term}":`, error);
      }
    }

    // Build suggestions with metrics
    const suggestions: any[] = [];
    let processed = 0;

    for (const [keyword, source] of allSuggestions) {
      if (processed >= maxLimit) break;

      try {
        // Search for this keyword to get metrics
        const results = await gplay.search({
          term: keyword,
          country: country as string,
          lang: lang as string,
          num: 50,
        });

        // Find app position
        const position = results.findIndex((app) => app.appId === appId);

        // Calculate difficulty based on competition
        const difficulty = calculateDifficulty(results);

        // Top competitors
        const topCompetitors = results.slice(0, 3).map((app, idx) => ({
          name: app.title,
          position: idx + 1,
          rating: app.score,
        }));

        suggestions.push({
          keyword,
          source,
          metrics: {
            position: position >= 0 ? position + 1 : null,
            competition: results.length,
            difficulty: difficulty.score,
            difficulty_label: difficulty.label,
          },
          top_competitors: topCompetitors,
        });

        processed++;

        // Rate limiting
        await new Promise((resolve) => setTimeout(resolve, 150));
      } catch (error) {
        console.error(`Error getting metrics for "${keyword}":`, error);
      }
    }

    // Sort by opportunity
    suggestions.sort((a, b) => {
      if (a.metrics.position !== null && b.metrics.position === null) return -1;
      if (a.metrics.position === null && b.metrics.position !== null) return 1;
      return a.metrics.difficulty - b.metrics.difficulty;
    });

    res.json({
      data: suggestions,
      meta: {
        app_id: appId,
        country: (country as string).toUpperCase(),
        total: suggestions.length,
        generated_at: new Date().toISOString(),
      },
    });
  } catch (error) {
    console.error('App suggestions error:', error);
    res.status(500).json({ error: 'Failed to get suggestions' });
  }
});

function extractSeedTerms(
  name: string,
  description: string
): { term: string; source: string }[] {
  const seeds: { term: string; source: string }[] = [];
  const stopWords = new Set([
    'the', 'and', 'for', 'with', 'your', 'you', 'from', 'that', 'this',
    'are', 'was', 'have', 'has', 'will', 'can', 'app', 'new', 'free',
  ]);

  // Tokenize name
  const nameWords = name
    .toLowerCase()
    .replace(/[^a-z\s]/g, ' ')
    .split(/\s+/)
    .filter((w) => w.length >= 3 && !stopWords.has(w));

  for (const word of nameWords.slice(0, 5)) {
    seeds.push({ term: word, source: 'app_name' });
  }

  // Tokenize description (first 500 chars)
  const descWords = description
    .substring(0, 500)
    .toLowerCase()
    .replace(/[^a-z\s]/g, ' ')
    .split(/\s+/)
    .filter((w) => w.length >= 4 && !stopWords.has(w));

  for (const word of descWords.slice(0, 5)) {
    if (!seeds.find((s) => s.term === word)) {
      seeds.push({ term: word, source: 'app_description' });
    }
  }

  return seeds.slice(0, 10);
}

function calculateDifficulty(results: any[]): { score: number; label: string } {
  const count = results.length;

  if (count === 0) {
    return { score: 0, label: 'easy' };
  }

  // Score based on result count (0-40)
  const resultScore = Math.min(40, count / 1.25);

  // Score based on top 10 strength (0-60)
  const top10 = results.slice(0, 10);
  let strengthScore = 0;

  for (const app of top10) {
    const rating = app.score || 0;
    const reviews = (app as any).ratings || 1;
    strengthScore += rating * Math.log10(Math.max(1, reviews));
  }
  strengthScore = Math.min(60, (strengthScore / 10) * 6);

  const score = Math.round(resultScore + strengthScore);
  const clampedScore = Math.max(0, Math.min(100, score));

  let label: string;
  if (clampedScore <= 25) label = 'easy';
  else if (clampedScore <= 50) label = 'medium';
  else if (clampedScore <= 75) label = 'hard';
  else label = 'very_hard';

  return { score: clampedScore, label };
}

export default router;
