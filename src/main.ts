import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';

async function bootstrap() {
  // const app = await NestFactory.create(AppModule);
  const fs = require('fs');
  const keyFile = fs.readFileSync('C:/Certbot/archive/ecmrare.com/key.pem');
  const certFile = fs.readFileSync('C:/Certbot/archive/ecmrare.com/cert.pem');
  const app = await NestFactory.create(AppModule, {
    httpsOptions: {
      key: keyFile,
      cert: certFile,
    },
  });

  // Enable CORS
  app.enableCors({
    origin: ['http://localhost:5173'], // Frontend URL
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization'],
    credentials: true,
  });

  // Swagger configuration
  const config = new DocumentBuilder()
    .setTitle('Ticket Management API')
    .setDescription('API documentation for Ticket Management System')
    .setVersion('1.0')
    .addBearerAuth()
    .addTag('auth', 'Authentication endpoints')
    .addTag('tickets', 'Ticket management endpoints')
    .addTag('wallet', 'Wallet management endpoints')
    .addTag('batch-processing', 'Batch processing endpoints')
    .addTag('dashboard', 'Dashboard endpoints')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api', app, document);

  await app.listen(process.env.PORT ?? 3000);
}
bootstrap();
