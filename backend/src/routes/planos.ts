import express from 'express';
import { PlanosController } from '../controllers/PlanosController';

const router = express.Router();

router.get('/', PlanosController.buscaPlanos);

export default router;