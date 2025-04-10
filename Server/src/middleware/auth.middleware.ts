import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import dotenv from "dotenv";
dotenv.config();
// Augment the Request type to include userId
declare global {
  namespace Express {
    interface Request {
      userId?: string; // Adjust the type according to how you store userId
      currentAdminId?: string; // Adjust the type according to how you store userId
    }
  }
}

const JWT_SECRET =
  process.env.JWT_SECRET || "uknowme";

export const verifyToken = (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) {
    return res.status(403).json({ message: "No token provided" });
  }

  jwt.verify(token, JWT_SECRET, (err: any, decoded: any) => {
    if (err) {
      return res
        .status(401)
        .json({ message: "Unauthorized", error: err.message });
    }

    req.userId = decoded.userId; // Now TypeScript recognizes `userId`
    req.currentAdminId = decoded.currentAdminId;
    next();
  });
};
