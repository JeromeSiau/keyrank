import { Router, Request, Response } from 'express';
import gplay from 'google-play-scraper';

const router = Router();

// Map category IDs to human-readable names
const categoryNames: Record<string, string> = {
  APPLICATION: 'All Apps',
  ART_AND_DESIGN: 'Art & Design',
  AUTO_AND_VEHICLES: 'Auto & Vehicles',
  BEAUTY: 'Beauty',
  BOOKS_AND_REFERENCE: 'Books & Reference',
  BUSINESS: 'Business',
  COMICS: 'Comics',
  COMMUNICATION: 'Communication',
  DATING: 'Dating',
  EDUCATION: 'Education',
  ENTERTAINMENT: 'Entertainment',
  EVENTS: 'Events',
  FINANCE: 'Finance',
  FOOD_AND_DRINK: 'Food & Drink',
  GAME: 'Games',
  HEALTH_AND_FITNESS: 'Health & Fitness',
  HOUSE_AND_HOME: 'House & Home',
  LIBRARIES_AND_DEMO: 'Libraries & Demo',
  LIFESTYLE: 'Lifestyle',
  MAPS_AND_NAVIGATION: 'Maps & Navigation',
  MEDICAL: 'Medical',
  MUSIC_AND_AUDIO: 'Music & Audio',
  NEWS_AND_MAGAZINES: 'News & Magazines',
  PARENTING: 'Parenting',
  PERSONALIZATION: 'Personalization',
  PHOTOGRAPHY: 'Photography',
  PRODUCTIVITY: 'Productivity',
  SHOPPING: 'Shopping',
  SOCIAL: 'Social',
  SPORTS: 'Sports',
  TOOLS: 'Tools',
  TRAVEL_AND_LOCAL: 'Travel & Local',
  VIDEO_PLAYERS: 'Video Players & Editors',
  WEATHER: 'Weather',
  // Game subcategories
  GAME_ACTION: 'Action Games',
  GAME_ADVENTURE: 'Adventure Games',
  GAME_ARCADE: 'Arcade Games',
  GAME_BOARD: 'Board Games',
  GAME_CARD: 'Card Games',
  GAME_CASINO: 'Casino Games',
  GAME_CASUAL: 'Casual Games',
  GAME_EDUCATIONAL: 'Educational Games',
  GAME_MUSIC: 'Music Games',
  GAME_PUZZLE: 'Puzzle Games',
  GAME_RACING: 'Racing Games',
  GAME_ROLE_PLAYING: 'Role Playing Games',
  GAME_SIMULATION: 'Simulation Games',
  GAME_SPORTS: 'Sports Games',
  GAME_STRATEGY: 'Strategy Games',
  GAME_TRIVIA: 'Trivia Games',
  GAME_WORD: 'Word Games',
};

router.get('/', async (_req: Request, res: Response) => {
  try {
    // Fetch categories dynamically from Google Play
    const categoryIds = await gplay.categories();

    // Map to objects with id and name
    const categories = categoryIds.map((id: string) => ({
      id,
      name: categoryNames[id] || id.replace(/_/g, ' ').replace(/\b\w/g, (c) => c.toUpperCase()),
    }));

    res.json({ categories });
  } catch (error) {
    console.error('Categories fetch error:', error);

    // Fallback to static list if dynamic fetch fails
    const fallbackCategories = Object.entries(categoryNames).map(([id, name]) => ({
      id,
      name,
    }));

    res.json({ categories: fallbackCategories });
  }
});

export default router;
