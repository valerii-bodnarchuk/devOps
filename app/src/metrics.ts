import { collectDefaultMetrics, Registry, Histogram } from 'prom-client';
import { Request, Response } from 'express';

export const register = new Registry();
collectDefaultMetrics({ register });

const httpDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'code'],
  buckets: [0.05, 0.1, 0.3, 0.5, 1, 2, 5]
});
register.registerMetric(httpDuration);

export const metricsMiddleware = async (_req: Request, res: Response) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
};