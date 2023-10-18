import { Request, Response } from 'express';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config();

export class FileController {

    static async getPublicFiles(req: Request, res: Response) {
        console.log(req.params.id);
        return res.send({ arquivos: ['arquivo1', 'arquivo2'] });
    }

    static async getPrivatetFiles(req: Request, res: Response) {
        console.log(req.params.id);
        return res.send({ arquivos: ['arquivo1', 'arquivo2'] });
    }

    static async middleware(req: Request, res: Response) {
        try {
            const token = String(req.headers.authorization).split('Bearer ')[1];
            const tokenDescriptografado = jwt.decode(token);
            const teste = jwt.verify(token, String(process.env.SECRET));
            console.log(token, tokenDescriptografado, teste);
            const file = req.files;
            console.log(file);

            if (!file || file.length === 0) {
                return res.status(400).send('Nenhum arquivo foi enviado.');
            }

            return res.status(200).send('Arquivo recebido com sucesso.');
        } catch (error) {
            console.log(error);
            return res.status(500).send('Erro ao processar arquivo.');
        }
    }

}