import {
  Controller,
  Post,
  UploadedFile,
  UseInterceptors,
  HttpStatus,
  HttpException,
  HttpCode,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { extname } from 'path';

const UPLOAD_FOLDER = './uploads'; // Ensure this folder exists

function editFileName(req, file, callback) {
  // Generates unique filename
  const name = file.originalname.split('.')[0];
  const fileExtName = extname(file.originalname);
  const randomName = Array(4)
    .fill(null)
    .map(() => Math.round(Math.random() * 16).toString(16))
    .join('');
  callback(null, `${name}-${randomName}${fileExtName}`);
}

@Controller()
export class AppController {
  @Post('upload')
  @HttpCode(HttpStatus.CREATED)
  @UseInterceptors(
    FileInterceptor('file', {
      storage: diskStorage({
        destination: UPLOAD_FOLDER,
        filename: editFileName,
      }),
      // You can still use file filters & validators here
    }),
  )
  async uploadFile(@UploadedFile() file) {
    try {
      if (!file) {
        throw new HttpException('No file uploaded', HttpStatus.BAD_REQUEST);
      }

      // your normal logic
      const fileUrl = `${process.env.API_URL}/uploads/${file.filename}`;

      // Optionally save fileUrl to DB here

      return {
        message: 'success',
        fileUrl,
      };
    } catch (error) {
      // You can log the error here if needed
      throw new HttpException(
        error.message || 'File upload failed',
        error.status || HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }
}
