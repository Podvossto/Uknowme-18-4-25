import { Router } from "express";
import { getCourseById, getAllCourses,getUser } from "../controllers/course.controller";
import { verifyToken } from "../middleware/auth.middleware";

const router = Router();

/**
 * @swagger
 * tags:
 *   name: Courses
 *   description: API สำหรับจัดการคอร์สเรียน
 */

/**
 * @swagger
 * /api/courses/{id}:
 *   get:
 *     summary: ดึงข้อมูลคอร์สตาม ID
 *     tags: [Courses]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID ของคอร์สที่ต้องการดึงข้อมูล
 *     responses:
 *       200:
 *         description: ดึงข้อมูลคอร์สสำเร็จ
 *         content:
 *           application/json:
 *             schema:
 *               $ref: '#/components/schemas/Course'
 *       404:
 *         description: ไม่พบคอร์สที่ระบุ
 *       500:
 *         description: เกิดข้อผิดพลาดภายในเซิร์ฟเวอร์
 */
router.get("/courses/:id", 
    verifyToken, 
    getCourseById);

/**
 * @swagger
 * /api/courses:
 *   get:
 *     summary: ดึงข้อมูลคอร์สทั้งหมด
 *     tags: [Courses]
 *     responses:
 *       200:
 *         description: ดึงข้อมูลคอร์สทั้งหมดสำเร็จ
 *         content:
 *           application/json:
 *             schema:
 *               type: array
 *               items:
 *                 $ref: '#/components/schemas/Course'
 *       500:
 *         description: เกิดข้อผิดพลาดภายในเซิร์ฟเวอร์
 */
router.get("/courses", getAllCourses);

/**
 * @swagger
 * /api/v1/user/courses/{id}:
 *   get:
 *     summary: ดึงข้อมูลคอร์สของผู้ใช้ตาม ID
 *     tags: [Courses]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         schema:
 *           type: string
 *         required: true
 *         description: ID ของผู้ใช้ที่ต้องการดึงข้อมูลคอร์ส
 *     responses:
 *       200:
 *         description: ดึงข้อมูลคอร์สของผู้ใช้สำเร็จ
 *         content:
 *           application/json:
 *             schema:
 *               type: object
 *               properties:
 *                 user:
 *                   $ref: '#/components/schemas/User'
 *                 courses:
 *                   type: array
 *                   items:
 *                     $ref: '#/components/schemas/Course'
 *       404:
 *         description: ไม่พบผู้ใช้ที่ระบุ
 *       500:
 *         description: เกิดข้อผิดพลาดภายในเซิร์ฟเวอร์
 */
router.get("/v1/user/courses/:id", verifyToken, getUser);

export default router;
