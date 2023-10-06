import express, { Request, Response } from 'express';
import { UserController } from '../controllers/UserController';
import middleware from '../config/middleware';

const router = express.Router();

router.post('/', middleware, UserController.criaUsuario);

router.post('/login', middleware, UserController.login);

export default router;