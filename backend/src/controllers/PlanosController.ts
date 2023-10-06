import express, { Request, Response } from 'express';
import { buscaTodosPlanos } from '../helpers/planos';

export class PlanosController {
    static async buscaPlanos (req: Request, res: Response) {
        try {
            const planos = await buscaTodosPlanos();
            return res.send(planos);
        } catch (error) {
            console.log(error);
            return res.status(500).send([]);
        }
    }
}