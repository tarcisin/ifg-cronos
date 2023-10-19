import express, { Request, Response } from 'express';
import middleware from '../config/middleware';
import { FileController } from '../controllers/FileController';

const router = express.Router();

// Rota para upload de arquivos
router.post('/', middleware, FileController.uploadFile);

router.get('/:id', middleware, FileController.arquivosCliente);

export default router;