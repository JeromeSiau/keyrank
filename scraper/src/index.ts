import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import searchRouter from './routes/search';
import appRouter from './routes/app';
import reviewsRouter from './routes/reviews';
import suggestionsRouter from './routes/suggestions';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;

app.use(cors());
app.use(express.json());

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

// Routes
app.use('/search', searchRouter);
app.use('/app', appRouter);
app.use('/reviews', reviewsRouter);
app.use('/suggestions', suggestionsRouter);

app.listen(PORT, () => {
  console.log(`Google Play scraper running on port ${PORT}`);
});
