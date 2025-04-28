import * as argon2  from "argon2";

const password = "password123";

const hashedPassword = await argon2.hash(password);


console.log("Hashed Password:", hashedPassword);

const isPasswordValid = await argon2.verify(hashedPassword, password);
console.log("Is Password Valid:", isPasswordValid);

const isPasswordInvalid = await argon2.verify(hashedPassword, "wrongpassword");
console.log("Is Password Invalid:", isPasswordInvalid);