import { Router, Request, Response } from 'express';
import crypto from 'crypto';
import gplay from 'google-play-scraper';

const router = Router();

router.get('/:appId', async (req: Request, res: Response) => {
  try {
    const { appId } = req.params;
    const { country = 'us', lang = 'en', sort = 'newest', num = 100 } = req.query;
    const cappedNum = Math.min(Number(num), 500);

    const sortMap: Record<string, any> = {
      newest: gplay.sort.NEWEST,
      rating: gplay.sort.RATING,
      helpfulness: gplay.sort.HELPFULNESS,
    };

    const reviewsResult = await gplay.reviews({
      appId,
      country: country as string,
      lang: lang as string,
      sort: sortMap[sort as string] || gplay.sort.NEWEST,
      num: cappedNum,
    });

    // Handle both array and object with data property
    const reviewsArray = Array.isArray(reviewsResult) ? reviewsResult : (reviewsResult as any).data || [];

    const formatted = reviewsArray.map((review: any) => {
      const fallbackId = crypto
        .createHash('sha1')
        .update(`${appId}|${review.userName || ''}|${review.score || ''}|${review.date || ''}|${review.text || ''}`)
        .digest('hex');

      return {
        review_id: review.id || fallbackId,
        author: review.userName,
        rating: review.score,
        title: review.title || null,
        content: review.text,
        version: review.version,
        reviewed_at: review.date,
        thumbs_up: review.thumbsUp,
        reply_date: review.replyDate,
        reply_text: review.replyText,
      };
    });

    res.json({ reviews: formatted });
  } catch (error) {
    console.error('Reviews error:', error);
    res.status(500).json({ error: 'Failed to fetch reviews' });
  }
});

export default router;
