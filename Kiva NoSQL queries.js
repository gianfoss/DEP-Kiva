db.loans.find({})

/*loans where funded_amount is greater than 200 and the language is English*/
db.loans.where("funded_amount").gte(200)
        .where("original_language").eq("English")


/*Loans where activity is Agriculture or Food and funded_amount<500 dollars in USD*/
db.loans.where("activity").eq("Agriculture").eq("Food")
        .where("funded_amount").lte(200)
        .where("currency").eq("USD")
        
/*Loans where the primary borrower is male, and activity is Personal Housing expenses */
db.loans.where("borrowers.0.gender").eq("male")
        .where("activity").eq("Personal Housing Expenses")






