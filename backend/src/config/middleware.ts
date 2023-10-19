import multer from "multer";
import fs from "fs";

const storage = multer.diskStorage({
    destination: (req, file, cb) => {
        const uploadPath = 'uploads/';
        // Verifique se a pasta "uploads" existe, senão, crie-a
        if (!fs.existsSync(uploadPath)) {
            fs.mkdirSync(uploadPath, { recursive: true });
        }
        cb(null, uploadPath); // Pasta onde os arquivos serão salvos
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + '-' + file.originalname); // Nome do arquivo no destino
    },
});

const middleware = multer({ storage }).array('file');

export default middleware;
