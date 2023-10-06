import express, { Request, Response } from 'express';
import middleware from '../config/middleware';
import { FileController } from '../controllers/FileController';

const router = express.Router();

// Rota para listar arquivos públicos
router.get('/', FileController.getPublicFiles);

// Rota para listar arquivos públicos
router.get('/:id', FileController.getPrivatetFiles);

// Rota para upload de arquivos
router.post('/', middleware, FileController.middleware);

export default router;