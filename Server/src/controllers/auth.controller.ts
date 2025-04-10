import { Request, Response } from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import { MongoClient } from "mongodb";
import dotenv from "dotenv";

dotenv.config();
const JWT_SECRET = process.env.JWT_SECRET || "uknowme";
const REFRESH_TOKEN_SECRET =
  process.env.REFRESH_TOKEN_SECRET || "your_refresh_secret";
const MONGODB_URI =
  process.env.MONGODB_URI || "mongodb://127.0.0.1:27017/Uknowmedatabase";

// Handler for Login
export const login = async (req: Request, res: Response) => {
  let client;
  try {
    const { email, password, role } = req.body;
    if (!email || !password) {
      return res
        .status(400)
        .json({ message: "Email and password are required" });
    }

    client = new MongoClient(MONGODB_URI);
    await client.connect();
    const database = client.db();
    let user;

    if (role === "admin") {
      const adminsCollection = database.collection("admins");
      user = await adminsCollection.findOne({ email });
    } else {
      const usersCollection = database.collection("users");
      user = await usersCollection.findOne({ email });
    }

    if (!user) {
      return res.status(401).json({ message: "Invalid email or password" });
    }

    if (user.bond_status && user.bond_status.status === "deactive") {
      return res.status(403).json({
        message: "Your account has been deactivated, please contact the admin.",
        showAlert: true,
      });
    }

    const isValid = await bcrypt.compare(password, user.password);
    if (!isValid) {
      return res.status(401).json({ message: "Invalid email or password" });
    }

    const token = jwt.sign(
      { userId: user._id.toString(), email: user.email, role: user.role },
      JWT_SECRET,
      { expiresIn: "10h" }
    );

    const refreshToken = jwt.sign(
      { userId: user._id.toString(), role: user.role },
      REFRESH_TOKEN_SECRET,
      { expiresIn: "15m" }
    );

    let redirectInfo;
    if (role === "admin") {
      redirectInfo = {
        path: "/AdminDashboard",
        permissions: user.permissions || [],
      };
    } else {
      redirectInfo = {
        path: "/UserHomepage",
        enrolledCourses: user.courses_enrolled || [],
      };
    }

    const userData = {
      id: user._id.toString(),
      name: user.name,
      email: user.email,
      role: user.role,
    };

    res.json({
      message: "Login successful",
      user: userData,
      redirectInfo,
      token,
      refreshToken,
    });
  } catch (error) {
    console.error("Error logging in:", error);
    res.status(500).json({ message: "Internal server error" });
  } finally {
    if (client) {
      await client.close();
    }
  }
};

// Handler for Signup
export const signup = async (req: Request, res: Response) => {
  let client: MongoClient | null = null;
  try {
    client = new MongoClient(MONGODB_URI);
    await client.connect();
    const database = client.db("Uknowmedatabase");
    const users = database.collection("users");
    const { name, company, citizenId, email, phone } = req.body;

    const existingUser = await users.findOne({
      $or: [{ email }, { citizen_id: citizenId }],
    });

    if (existingUser) {
      if (existingUser.email === email) {
        return res.status(400).json({
          message: "duplicate_email",
          detail: "Email already registered",
        });
      } else if (existingUser.citizen_id === citizenId) {
        return res.status(400).json({
          message: "duplicate_citizen_id",
          detail: "Citizen ID already registered",
        });
      }
    }

    const hashedPassword = await bcrypt.hash(citizenId, 10);

    const newUser = {
      name,
      company,
      citizen_id: citizenId,
      email,
      phone,
      password: hashedPassword,
      password_changed: false,
      role: "user",
      bond_status: {
        status: "inactive",
        start_date: null,
        end_date: null,
      },
      courses_enrolled: [],
      created_at: new Date(),
      updated_at: new Date(),
    };

    const result = await users.insertOne(newUser);

    res.status(201).json({
      message:
        "User registered successfully. Please login using your Citizen ID as password.",
      userId: result.insertedId,
      role: "user",
    });
  } catch (error: unknown) {
    console.error("Error registering user:", error);

    // Type Guard for Error type
    if (error instanceof Error) {
      res
        .status(500)
        .json({ message: "Internal server error", detail: error.message });
    } else {
      res.status(500).json({ message: "Unknown error occurred" });
    }
  } finally {
    if (client) {
      await client.close();
    }
  }
};

// Handler for Token Validation
export const validateToken = (req: Request, res: Response) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) {
    return res
      .status(401)
      .json({ valid: false, message: "Token not provided" });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    return res.json({ valid: true, user: decoded });
  } catch (error: unknown) {
    console.error("Token validation error:", error);

    // Type Guard for Error type
    if (error instanceof Error) {
      if (error.name === "TokenExpiredError") {
        return res
          .status(401)
          .json({ valid: false, message: "Token has expired" });
      } else if (error.name === "JsonWebTokenError") {
        return res.status(401).json({ valid: false, message: "Invalid token" });
      }
    }

    // Handle unexpected errors
    return res
      .status(500)
      .json({ valid: false, message: "Internal server error" });
  }
};
// Handler for Refresh Token
export const refreshToken = (req: Request, res: Response) => {
  const refreshToken = req.body.token;

  if (!refreshToken) {
    return res.status(401).json({ message: "Refresh token required" });
  }

  try {
    const user = jwt.verify(refreshToken, REFRESH_TOKEN_SECRET) as {
      userId: string;
      role: string;
    };
    const newToken = jwt.sign(
      { userId: user.userId, role: user.role },
      JWT_SECRET,
      { expiresIn: "1h" }
    );
    res.json({ token: newToken });
  } catch (error) {
    console.error("Error refreshing token:", error);
    return res.status(403).json({ message: "Invalid refresh token" });
  }
};
