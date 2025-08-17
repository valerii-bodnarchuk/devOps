import express from 'express';
import helmet from 'helmet';
import morgan from 'morgan';
import routes from './routes/index.js';
import { metricsMiddleware } from './metrics.js';

const app = express();
app.use(helmet());
app.use(express.json());
app.use(morgan('combined'));

app.get('/health', (_req, res) => res.status(200).json({ ok: true }));
app.get('/metrics', metricsMiddleware);
app.use('/api', routes);

const port = process.env.PORT || 3000;
app.listen(port, () => console.log(`api up on :${port}`));

process.on('SIGTERM', () => process.exit(0));
process.on('SIGINT', () => process.exit(0));