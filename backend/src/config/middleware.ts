import multer from "multer";

const storage = multer.memoryStorage();
const middleware = multer({ storage }).array('file');

export default middleware;