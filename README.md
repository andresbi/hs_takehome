#### WELCOME to H-bnb, Where Data Drives Your Comfort and Experience!

### Note to Reviewer
- The Analyses folder contains the queries and results for the questions outlined in the PDF. You can access it [here](analyses)
- The data lineage can be found in the images folder. View it [here](images/lineage.png)
- The project is built to run on Snowflake and only requires the installation of dbt-snowflake in a virtual environment to get started

### Assumptions and Callouts
    - This is an MVP model, with business requirements derived primarily from the exercise questions, leading to the exclusion of many fields in the final data mart. 
        - For example, only Neighborhood was retained from the listing data as other fields were mostly not obviously useful or "tricky" because they are not time-bound.
        - Due to time constraints, I chose not to implement certain things that I would in a production setting
        - Data Testing: I implemented only one basic data test for this exercise, rather than a comprehensive testing framework.
    - To recognize revenue from the calendar, I used today's date to determine if a reservation had already occurred and should be counted as revenue. This approach includes all relevant records.
    - The Generated_Reviews data source lacked the information needed to connect reviews to records in the final mart. In a real-world scenario, I would consult stakeholders to gain a better understanding of their review analysis requirements.
    - I chose to ignore an edge case in Question 3B, as I believe it wasn't the designer's intention to address it. The issue would occur when a listing's has_lockbox changes from TRUE to FALSE during a reservation, potentially leading to incorrect results. This does not happen in the given dataset, and fixing this would require custom logic for a specific amenities combination, which I assumed wasn't the goal of the exercise. 

### My Approach to the Exercise
    1) Define the problem statement --> (Lack of insights in Revenue, Occupancy, Amenities, Reviews) and goal --> (Data model to enable the right insights)
    2) Query the source data to explore and test key aspects, such as the number of listings, the timeframe, data structure, referential integrity, and uniqueness:
        - Example: reservation_id in the Calendar is not unique across listings, which impacts downstream transformations.
        - Example: The timing of reviews is misaligned with the Calendar records.
        - Example: Listing data is current data, which would not be useful for historical context
    3) Analyze business requirements from PDF
        - Define Key Metrics to provide: Revenue & Occupancy Rate
        - Craft queries to answer the guiding questions in PDF.
        - Anticipate additional Analytic needs not covered above
    4) Plan and structure the dbt project accordingly.
    5) Anticipate future needs, such as converting additional amenities from JSON into columns.
    6) Develop the necessary transformations.
    7) Validate the final mart against the provided tips (from the PDF) and make adjustments as needed.

### Data Model Explanation
    Output: A single table capturing the daily status of each listing, designed to provide insights into key business metrics and operational performance.
    Example:
    - What is the occupancy rate for listings with certain amenities?
    - What is the average monthly price of listings?
    - Which listings provide the most revenue?
    - What is the average reservation length?

### dbt-project Structure
    Staging:
        - Selects only the required fields.
        - Renames fields for clarity (e.g., available → is_available).
        - Performs basic data cleaning (e.g., converts datetime fields to date where appropriate).
        - Transforms the changelog into a Type 2 SCD using a window function for easier analysis.
        - Simple transformations include:
            - Creating boolean fields for clarity (e.g., is_reserved is set to True if there is a reservation_id).
            - Adding a revenue column to ensure analytic queries are accurate (e.g., preventing the sum of price for unreserved or future dates).

    Intermediate:
        - Applies further DRY (Don't Repeat Yourself) transformations by using Jinja to extract the required amenities from the listing's JSON field.
        - Future amenities can easily be added by updating the Set variable.
        - Joins tables to create a unified model for the mart.
        - Uses window functions to simplify complex queries for end-users.

    Mart:
        - Reorders fields to streamline analysis.
        - Adds a simple data test, though a better test would verify the uniqueness listing_id and date together.
            - This can be achieved by installing the dbt_utils package and using the unique_combination_of_columns test, 
            - Or by generating a surrogate key using the generate_surrogate_key macro and testing its uniqueness.
            - Or with a singular data test


