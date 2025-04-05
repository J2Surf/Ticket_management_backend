import * as crypto from 'crypto';

// Generate a random 32-byte (256-bit) key
const keyBytes = crypto.randomBytes(32);
const encryptionKey = keyBytes.toString('base64');

console.log('Generated Encryption Key:');
console.log('Bytes length:', keyBytes.length); // Will show 32
console.log('Base64 representation:', encryptionKey);
console.log('\nAdd this key to your .env file as:');
console.log(`ENCRYPTION_KEY=${encryptionKey}`);
