# Check-IkeaStock.ps1

This is just a quick script I wrote to check Ikea stock in my area for a short list
of products that I need for a project.

To modify it for your needs, edit the `$products` and `$stores` hashtables to include
the products you're looking for and which stores to include.

## Prerequisites

* [Node.js](https://nodejs.org/en/download/)
* [ikea-availability-checker](https://www.npmjs.com/package/ikea-availability-checker)

## Usage

Run the script and output results to the console:

```powershell
PS> .\Check-IkeaStock.ps1
```

Run the script and output results to a sortable GridView UI:

```powershell
PS> .\Check-IkeaStock.ps1 | Out-GridView
```

## Notes

This script could be optimized to run a lot faster than it does, since `ikea-availability-checker`
supports querying multiple stores at once, for multiple products.
