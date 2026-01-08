import { Router, Request, Response } from 'express';
import gplay from 'google-play-scraper';

const router = Router();

router.get('/:appId', async (req: Request, res: Response) => {
  try {
    const { appId } = req.params;
    const { country = 'us', lang = 'en' } = req.query;

    let appData: any = null;

    // Try direct app lookup first
    try {
      const app = await gplay.app({
        appId,
        country: country as string,
        lang: lang as string,
      });

      appData = {
        google_play_id: app.appId,
        name: app.title,
        icon_url: app.icon,
        developer: app.developer,
        developer_id: app.developerId,
        description: app.description,
        rating: app.score,
        rating_count: app.ratings,
        reviews_count: app.reviews,
        price: app.price,
        free: app.free,
        currency: app.currency,
        version: app.version,
        updated: app.updated,
        genre: app.genre,
        genre_id: app.genreId,
        screenshots: app.screenshots,
        store_url: app.url,
      };
    } catch (directError) {
      console.warn('Direct app lookup failed, trying search fallback:', directError);

      // Fallback: search for the app by ID
      const searchResults = await gplay.search({
        term: appId,
        country: country as string,
        lang: lang as string,
        num: 50,
      });

      const matchedApp = searchResults.find((a) => a.appId === appId);

      if (matchedApp) {
        appData = {
          google_play_id: matchedApp.appId,
          name: matchedApp.title,
          icon_url: matchedApp.icon,
          developer: matchedApp.developer,
          developer_id: matchedApp.developerId,
          description: matchedApp.summary || '',
          rating: matchedApp.score,
          rating_count: (matchedApp as any).ratings || 0,
          reviews_count: 0,
          price: (matchedApp as any).price || 0,
          free: matchedApp.free,
          currency: (matchedApp as any).currency || 'USD',
          version: null,
          updated: null,
          genre: null,
          genre_id: null,
          screenshots: [],
          store_url: matchedApp.url,
        };
      }
    }

    if (appData) {
      res.json(appData);
    } else {
      res.status(404).json({ error: 'App not found' });
    }
  } catch (error) {
    console.error('App details error:', error);
    res.status(404).json({ error: 'App not found' });
  }
});

export default router;
