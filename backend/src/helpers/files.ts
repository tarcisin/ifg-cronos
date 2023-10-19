import { client } from "../config/db";

const database = client.db('cronos');
const collection = database.collection('arquivos');

export const salvaArquivos = async (arquivo: Express.Multer.File, idUsuario: string) => {
    try {
        const salvaArquivo = await collection.insertOne({
            idUsuario,
            tamanhoArquivo: arquivo.size,
            nomeArquivo: arquivo.originalname,
            dataModificacao: new Date(),
            tipoMIME: arquivo.mimetype
        });
        return salvaArquivo;
    } catch (error) {
        console.log(error);
        throw new Error('Erro ao salvar arquivo.');
    }
}

export const buscaArquivosPorIdCliente = async (idCliente: string) => {
    try {
        const consulta = { idUsuario: idCliente };
        const resultado = await collection.find(consulta, { projection: { idUsuario: 0 } }).toArray();
        return resultado;
    } catch (error) {
        console.log(error);
        throw new Error('Erro ao buscar arquivos.');
    }
}