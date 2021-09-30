# Check-IkeaStock.ps1

Some quick and dirty scripts to check Ikea stock in my area for a short list
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

There's a second script creatively named `Check-IkeaStock2.ps1` that just runs
`ikea-availability-checker` passing in the two product IDs I currently need and the
two stores that carry the AXSTAD line that I'm willing to drive to. Output is just to
the console but is nicely-formatted text.

Note that when passing a list of store IDs on Windows the list needs to be in quotes.

```powershell
PS> .\Check-IkeaStock2.ps1
```

## Notes

This script could be optimized to run a lot faster than it does, since `ikea-availability-checker`
supports querying multiple stores at once, for multiple products.
