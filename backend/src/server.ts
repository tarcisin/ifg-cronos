import express, { Request, Response } from 'express';
import cors from 'cors';
import files from './routes/files';
import user from './routes/users';
import planos from './routes/planos';
import swaggerUI from 'swagger-ui-express';
import swaggerDocument from '../swagger.json'

const app = express()
const port = 3000

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use('/files', files);
app.use('/user', user);
app.use('/planos', planos);
app.use('/docs', swaggerUI.serve, swaggerUI.setup(swaggerDocument))

app.get('/', (req: Request, res: Response) => {
    res.send('Hello World!')
})

app.listen(port, () => {
    console.log(`Example app listening on port ${port}`)
})