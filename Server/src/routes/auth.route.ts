import { Router } from "express";
import {
  login,
  signup,
  validateToken,
  refreshToken,
} from "../controllers/auth.controller";
const router = Router();

router.post("/login", login);
router.post("/signup", signup);
router.get("/validate-token", validateToken);
router.post("/refresh-token", refreshToken);


export default router;

/**
 * @swagger
 * tags:
 *   name: Auth
 *   description: API สำหรับการจัดการการเข้าสู่ระบบและบัญชีผู้ใช้
 */

/**
 * @swagger
 * /api/login:
 *   post:
 *     summary: เข้าสู่ระบบสำหรับผู้ใช้หรือผู้ดูแลระบบ
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               email:
 *                 type: string
 *                 example: user@example.com
 *                 description: อีเมลผู้ใช้
 *               password:
 *                 type: string
 *                 example: รหัสผ่าน123
 *                 description: รหัสผ่าน
 *               role:
 *                 type: string
 *                 enum: [admin, user]
 *                 example: user
 *                 description: บทบาทของผู้ใช้ (admin หรือ user)
 *     responses:
 *       200:
 *         description: เข้าสู่ระบบสำเร็จ
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/LoginResponse'
 *       400:
 *         description: ไม่ได้ระบุอีเมลหรือรหัสผ่าน
 *       401:
 *         description: อีเมลหรือรหัสผ่านไม่ถูกต้อง
 *       403:
 *         description: บัญชีถูกระงับการใช้งาน
 */

/**
 * @swagger
 * /api/signup:
 *   post:
 *     summary: ลงทะเบียนผู้ใช้ใหม่
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               name:
 *                 type: string
 *                 example: สมชาย ใจดี
 *                 description: ชื่อผู้ใช้
 *               company:
 *                 type: string
 *                 example: บริษัท ตัวอย่าง จำกัด
 *                 description: ชื่อบริษัท
 *               citizenId:
 *                 type: string
 *                 example: 1234567890123
 *                 description: เลขบัตรประชาชน
 *               email:
 *                 type: string
 *                 example: user@example.com
 *                 description: อีเมล
 *               phone:
 *                 type: string
 *                 example: 0812345678
 *                 description: เบอร์โทรศัพท์
 *     responses:
 *       201:
 *         description: ลงทะเบียนผู้ใช้สำเร็จ
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 message:
 *                   type: string
 *                   description: ข้อความแจ้งสถานะ
 *                 userId:
 *                   type: string
 *                   description: ID ของผู้ใช้ที่ลงทะเบียน
 *                 role:
 *                   type: string
 *                   description: บทบาทของผู้ใช้
 *       400:
 *         description: อีเมลหรือเลขบัตรประชาชนซ้ำกับที่มีอยู่แล้ว
 *       500:
 *         description: เกิดข้อผิดพลาดภายในเซิร์ฟเวอร์
 */

/**
 * @swagger
 * /api/validate-token:
 *   get:
 *     summary: ตรวจสอบความถูกต้องของโทเคน
 *     tags: [Auth]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: โทเคนถูกต้อง
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 valid:
 *                   type: boolean
 *                   description: สถานะความถูกต้องของโทเคน
 *                 user:
 *                   type: object
 *                   description: ข้อมูลผู้ใช้
 *       401:
 *         description: โทเคนไม่ถูกต้องหรือไม่มีโทเคน
 *       500:
 *         description: เกิดข้อผิดพลาดภายในเซิร์ฟเวอร์
 */

/**
 * @swagger
 * /api/refresh-token:
 *   post:
 *     summary: ต่ออายุโทเคนที่หมดอายุ
 *     tags: [Auth]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             properties:
 *               token:
 *                 type: string
 *                 example: refresh-token-string
 *                 description: refresh token ที่ได้รับตอนเข้าสู่ระบบ
 *     responses:
 *       200:
 *         description: ต่ออายุโทเคนสำเร็จ
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 token:
 *                   type: string
 *                   description: โทเคนใหม่
 *       401:
 *         description: ต้องระบุ refresh token
 *       403:
 *         description: refresh token ไม่ถูกต้อง
 *       500:
 *         description: เกิดข้อผิดพลาดภายในเซิร์ฟเวอร์
 */
