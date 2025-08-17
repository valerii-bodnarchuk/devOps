import { Router } from 'express';
const routes = Router();

routes.get('/v1/ping', (_req, res) => res.json({ pong: true, ts: Date.now() }));

export default routes;