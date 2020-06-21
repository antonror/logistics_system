## Setup
Simple Rails project. Please do the following: 

1. bundle
2. rails db:create, rails db:migrate
3. run rspec

## Moteefe Coding Challenge
Moteefe is an international company providing print on demand service. We
have various products e.g
shirts, hoodies, mugs, cushions etc. Our suppliers are spread around the
world, therefore the delivery of
products depends on the region where they are shipped.
Your task is to implement a solution which gives us a number of days for
delivery and the amounts of shipments
and their details based on list of items in the basket and the region
where those items are supposed to be delivered.
There might be more shipments as not all suppliers provide all products.
Please, consider that this solution must receive parameters such as
shipping region and items which
are supposed to be ordered.

Use this pattern as "database" for your project, it's in a csv format.

````
product_name,supplier,delivery_times,in_stock
black_mug,Shirts4U,'{ "eu": 1, "us": 6, "uk": 2}',3
blue_t-shirt,Best Tshirts,'{ "eu": 1, "us": 5, "uk": 2}',10
white_mug,Shirts Unlimited,'{ "eu": 1, "us": 8, "uk": 2}',3
black_mug,Shirts Unlimited,'{ "eu": 1, "us": 7, "uk": 2}',4
pink_t-shirt,Shirts4U,'{ "eu": 1, "us": 6, "uk": 2}',8
pink_t-shirt,Best Tshirts,'{ "eu": 1, "us": 3, "uk": 2}',2
````


The outcome should be an object which should look like this:

````
{
delivery_date: '2020-03-10',
shipments: [
{
suplier: "Shirts4U",
delivery_date: '2020-03-09'
items: [
{
title: "tshirt",
count: 10
},
{
title: "hoodie",
count: 5
},
]
},
{
suplier: "BesT-Shirts",
delivery_date: '2020-03-10'
items: [
{
title: "mug",
count: 2
}
]]
}
}
````

Where
`delivery_date` is date of delivery relative to current date (if today
date is 2020-02-01 and days for delivery is 2, then `delivery_date` is
2020-02-03)
`shipments` is list of items that will be shipped by suppliers base on
the availability in stock. Each shipment should contain name of the
`supplier`,
`delivery_date` relative to the current date and list of items with their
`title` and `count`.

### Acceptance criteria
The following are the rules upon which our system works.
The number of delivery days is the **biggest** number of delivery days
from all items in basket

**Scenario 1**
Having a list of items containing product A with deliver time 3 days and
product B with delivery time 1 day
Then the deliver time is 3

**Scenario 2**
Having a product A from two suppliers A and B.
When supplier A deliver in product A in 3 days and supplier B deliver
product A in 2 days
Then delivery time for that product is 2 days

**Scenario 3**
Having a t-shirt and hoodie in the basket
When t-shirt can be shipped from supplier A and B
And hoodie can be shipped from supplier B na C
Then deliver the t-shirt and hoodie from supplier B
edge case: It's faster to deliver it separately

**Scenario 4**
Having a 10 T-shirt in the basket and two suppliers A and B
When there is only 6 T-shirts from supplier A and 7 T-shirts of supplier
B on stockThen there would be a two shipments one from supplier A with 6 T-shirts
and second from supplier B
edge case: split it into 3
