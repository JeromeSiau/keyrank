import { Router, Request, Response } from 'express';
import gplay from 'google-play-scraper';

const router = Router();

interface TopQuery {
  category?: string;
  country?: string;
  collection?: string;
  num?: number;
}

router.get('/', async (req: Request, res: Response) => {
  try {
    const {
      category = 'APPLICATION',
      country = 'us',
      collection = 'top_free',
      num = 100,
    } = req.query as unknown as TopQuery;

    // Map collection param to google-play-scraper collection enum
    const collectionMap: Record<string, gplay.collection> = {
      top_free: gplay.collection.TOP_FREE,
      top_paid: gplay.collection.TOP_PAID,
      top_grossing: gplay.collection.GROSSING,
      grossing: gplay.collection.GROSSING, // alias
    };

    const gplayCollection = collectionMap[collection] || gplay.collection.TOP_FREE;

    const results = await gplay.list({
      category: category as gplay.category,
      collection: gplayCollection,
      country: country,
      num: Math.min(Number(num), 200),
    });

    const formatted = results.map((app, index) => ({
      position: index + 1,
      google_play_id: app.appId,
      name: app.title,
      icon_url: app.icon,
      developer: app.developer,
      rating: app.score,
      rating_count: (app as any).ratings ?? 0,
      price: (app as any).price ?? 0,
      free: app.free,
    }));

    res.json({ results: formatted });
  } catch (error) {
    console.error('Top charts error:', error);
    res.status(500).json({ error: 'Failed to fetch top charts' });
  }
});

export default router;
