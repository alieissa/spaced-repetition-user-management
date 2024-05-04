-- Create spaced_repetition if it doesn't exist
SELECT 'CREATE DATABASE spaced_repetition' 
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'spaced_repetition')\gexec