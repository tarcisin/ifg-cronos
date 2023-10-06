import { client } from "../config/db";

const database = client.db('cronos');
const collection = database.collection('planos');

const buscaTodosPlanos = async () => {
    try {
        const planos = await collection.find({}).toArray();
        console.log(planos);
        return planos;
    } catch (error) {
        console.log(error);
        throw new Error("Erro ao buscar planos!");
    }
}

export {
    buscaTodosPlanos
}