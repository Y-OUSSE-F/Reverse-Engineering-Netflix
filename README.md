# Reverse-Engineering-Netflix

This project is my attempt to analyze and reconstruct a simplified version of Netflix’s database using SQL. The goal is to understand the logical structure of Netflix's database system and implement a well-defined relational schema based on theoretical assumptions.

## Features
- **Customer and Subscription Management:** Tracks users, subscriptions, and payment records.
- **Profile and Device Tracking:** Stores data on user profiles and the devices they use.
- **Media Catalog:** Organizes information about movies and series, including genres, ratings, and metadata.
- **Watch Records & Analytics:** Logs viewing habits, including watch duration, time of day, and device usage.

## Database Structure
**The project is built using a relational database model, containing the following entities:**

- Customer (CustomerID, Full_Name, Email, Birth_Date, Billing_Address, CreditCardNo)
- Subscription (SubscriptionID, Subscription_Tier, Start_Date, End_Date)
- Profile (ProfileID, Name, Create_Date)
- Device (DeviceID, Device_Type)
- Media (MediaID, Title, Release_Date, Actors, Directors, Rating)
- Genre (GenreID, Genre_Name)
- Watch_Record (Watch_Date, Duration, Watch_Time, ProfileID, DeviceID)
- Payment (PaymentID, SubscriptionID, Amount, Payment_Date)

## Final Comments
This was meant to just be my curious attempt to model what at least outwardly, we can infer about what Netflix looks like under the hood. I put my full throught process, as well as my logical design model into the .pdf slide show attached to this repo. My creation SQL scripts are attached, so feel free to try this on your own computer. I have inserted limited values, but you can always insert some more of your own!
