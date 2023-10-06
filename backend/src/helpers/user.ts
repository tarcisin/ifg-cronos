import { client } from '../config/db';
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config();

interface Usuario {
    _id?: string;
    email: string;
    senha: string;
    idPlano: string;
    criadoEm?: Date;
    armazenamentoUsado?: number;
}

const saltosBCrypt = 14;
const database = client.db('clientes');
const collection = database.collection('usuarios');

const verificaSeUsuarioExiste = async (email: string) => {
    try {
        const consulta = { email: email };
        const resultado = await collection.findOne(consulta);

        if (!resultado) {
            return false;
        }

        return true;
    } catch (error) {
        console.log(error);
        throw new Error('Erro ao verificar se o usuário existe.');
    }
}

const criptografaSenha = async (senha: string) => {
    try {
        const salt = await bcrypt.genSalt(saltosBCrypt);
        const hash = await bcrypt.hash(senha, salt);
        return hash;
    } catch (error: any) {
        throw new Error('Erro ao criar hash da senha: ' + error.message);
    }
}

const validaSenhaUsuario = async (email: string, senha: string) => {
    try {
        const usuario = await collection.findOne<Usuario>({ email });
        const senhaValida = await bcrypt.compare(senha, String(usuario?.senha));
        return senhaValida;
    } catch (error: any) {
        throw new Error('Erro ao verificar senha: ' + error.message);
    }
}

const criaJwt = (usuario: Usuario) => {
    try {
        const token = jwt.sign({
            id: usuario._id,
            email: usuario.email,
            idPlano: usuario.idPlano
        }, String(process.env.SECRET), { expiresIn: '1h' });
        return token;
    } catch (error: any) {
        throw new Error('Erro ao criar token: ' + error.message);
    }
}

const logaUsuario = async (email: string, senha: string) => {
    try {
        const usuario = await collection.findOne<Usuario>({ email });
        const senhaValida = await bcrypt.compare(senha, String(usuario?.senha));
        
        if(!senhaValida) {
            return { token: null, mensagem: 'Senha inválida!' };
        }
        const token = criaJwt(usuario as Usuario);
        return { token, mensagem: 'Login efetuado com sucesso!' };
    } catch (error: any) {
        throw new Error('Erro ao tentar fazer o login do usuário: ' + error.message);
    }
}

const cadastraNovoUsuario = async (props: Usuario) => {
    try {
        const usuario = await collection.insertOne({
            email: props.email,
            senha: await criptografaSenha(props.senha),
            idPlano: props.idPlano,
            criadoEm: new Date(),
            armazenamentoUsado: 0
        });
        return usuario.insertedId;
    } catch (error: any) {
        console.log(error.message);
        throw new Error('Erro ao cadastrar novo usuário! ');
    }
}

const validaDadosUsuario = (email: string, senha: string, idPlano: string = "123") => {
    try {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            return { dadosValidos: false, mensagem: 'E-mail inválido!' };
        }

        // Validação da senha - você pode adicionar suas próprias regras aqui (por exemplo, comprimento mínimo)
        if (senha.length < 8 || senha.length > 32) {
            return { dadosValidos: false, mensagem: 'A  senha deve ter entre 8 e 32 caracteres!' };
        }

        // Validação do ID do plano - exemplo básico para verificar se é uma string não vazia
        if (!idPlano || idPlano.trim() === "") {
            return { dadosValidos: false, mensagem: 'ID do plano inválido!' };
        }

        return { dadosValidos: true, mensagem: "" };
    } catch (error: any) {
        return { dadosValidos: false, mensagem: error.message };
    }
}

export {
    verificaSeUsuarioExiste,
    criptografaSenha,
    validaSenhaUsuario,
    cadastraNovoUsuario,
    validaDadosUsuario,
    logaUsuario
}
