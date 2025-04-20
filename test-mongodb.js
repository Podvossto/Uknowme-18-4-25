const { MongoClient } = require('mongodb');

// Connection URL
const url = 'mongodb://127.0.0.1:27017';
const dbName = 'Uknowmedatabase';

async function main() {
  const client = new MongoClient(url);

  try {
    // Connect to the MongoDB server
    await client.connect();
    console.log('Connected successfully to MongoDB server');

    // Get the database
    const db = client.db(dbName);
    
    // List all collections
    const collections = await db.listCollections().toArray();
    console.log('Collections in the database:');
    collections.forEach(collection => {
      console.log(` - ${collection.name}`);
    });

    // For each collection, count documents
    for (const collection of collections) {
      const count = await db.collection(collection.name).countDocuments();
      console.log(`Collection ${collection.name} has ${count} documents`);
      
      // Get a sample document if collection has documents
      if (count > 0) {
        const sample = await db.collection(collection.name).findOne();
        console.log(`Sample document from ${collection.name}:`, JSON.stringify(sample, null, 2));
      }
    }

  } catch (err) {
    console.error('Error connecting to MongoDB:', err);
  } finally {
    // Close the connection
    await client.close();
    console.log('Connection closed');
  }
}

main().catch(console.error); 