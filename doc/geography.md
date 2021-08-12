# Geography

An activity should[1] have a record of what countries it benefits.

This information is recorded as a flat list of countries.

**CHANGED** from before: no country is given "primary" recipient status.

RODA only records the country codes, and not any region information.

**CHANGED** from before: there is no longer a way to designate an entire region as the recipient. The regions are only shown as a helping tool, allowing users to select a group of countries at once, but not stored in the database.

The list of countries is populated from the eligible countries, which is a living list changing according to (WHOSE?) criteria.

The user interface consists of a form step, presenting a list of checkboxes with the countries' names, grouped by region.

Users can also use the CSV upload process, by including a semicolon separated list of country codes in their activity CSV in a "Benefitting Countries" column.

## Reporting

The data exported for IATI includes all the benefitting countries. Due to IATI rules, when reporting multiple recipient countries, they MUST report a percentage of the commitment value for each country, adding up exactly to 100.

**CHANGED** from before: As RODA doesn't currently record any weighting of the aid given to each country, it calculates this percentage by dividing 100 to the number of countries, and assigning any remainder to the last country in the list.

**CHANGED** from before: As RODA doesn't enforce the presence of benefitting countries, and there is no longer a way to designate "Developing countries, unspecified", the IATI XML may be invalid for some activities.

[1] At the time of writing there is no validation to enforce this, because as of writing this there is no decision on how to transform the data that was formerly presented as the region "Developing countries, unspecified".
