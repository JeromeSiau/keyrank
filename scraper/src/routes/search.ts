import { Router, Request, Response } from 'express';
import gplay from 'google-play-scraper';

const router = Router();

interface SearchQuery {
  term: string;
  country?: string;
  lang?: string;
  num?: number;
}

async function getSearchResults(term: string, country: string, lang: string, num: number) {
  const cappedNum = Math.min(num, 250);
  return gplay.search({
    term,
    country,
    lang,
    num: cappedNum,
  });
}

router.get('/', async (req: Request, res: Response) => {
  try {
    const { term, country = 'us', lang = 'en', num = 50 } = req.query as unknown as SearchQuery;

    if (!term || term.length < 2) {
      res.status(400).json({ error: 'Search term must be at least 2 characters' });
      return;
    }

    const results = await getSearchResults(term, country, lang, Number(num));

    const formatted = results.map((app, index) => ({
      position: index + 1,
      google_play_id: app.appId || '',
      name: app.title,
      icon_url: app.icon,
      developer: app.developer,
      rating: app.score,
      rating_count: (app as any).ratings ?? 0,
      price: (app as any).price ?? 0,
      free: app.free,
    })).filter((app) => app.google_play_id);

    res.json({ results: formatted });
  } catch (error) {
    console.error('Search error:', error);
    res.status(500).json({ error: 'Failed to search apps' });
  }
});

// Batch rankings endpoint
router.post('/rankings', async (req: Request, res: Response) => {
  try {
    const { app_id, keywords, country = 'us', lang = 'en' } = req.body;

    if (!app_id || !keywords || !Array.isArray(keywords)) {
      res.status(400).json({ error: 'app_id and keywords array required' });
      return;
    }

    const rankings: Record<string, number | null> = {};

    for (const keyword of keywords) {
      try {
        const results = await getSearchResults(keyword, country, lang, 250);

        const position = results.findIndex((app) => app.appId === app_id);
        rankings[keyword] = position >= 0 ? position + 1 : null;

        // Rate limiting delay
        await new Promise((resolve) => setTimeout(resolve, 200));
      } catch (error) {
        console.error(`Error searching keyword "${keyword}":`, error);
        rankings[keyword] = null;
      }
    }

    res.json({ app_id, country, rankings });
  } catch (error) {
    console.error('Rankings error:', error);
    res.status(500).json({ error: 'Failed to fetch rankings' });
  }
});

export default router;
