# Prerequisite: Install ikea-availability-checker NPM package
# https://www.npmjs.com/package/ikea-availability-checker

# Hashtable of product SKUs and # required for your project.
$products = [ordered]@{
  '00467908' = 4
  '00468390' = 1
  '10467936' = 1
  '30265452' = 2
  '30393652' = 2
  '30467935' = 2
  '60467934' = 2
  '80467914' = 2
  '30265386' = 2
  '90335211' = 1
  '50467920' = 2
  '80467933' = 2
}

# Hashtable of store names and IDs. You can find these by running a whole-country
# search for a product using ikea-availability-checker, e.g.:
# ikea-availability stock --country us 30265386
$stores = [ordered]@{
  'Woodbridge' = 168
  'Norfolk' = 569
  'CollegePark' = 411
}

$items = @()

foreach ($product in $products.Keys) {
  $folder = $product.Substring(5)
  $productUrl = "https://www.ikea.com/us/en/products/$folder/$product.json"
  $productInfo = Invoke-RestMethod -Uri $productUrl -Method Get
  Write-Host "$product - $($productInfo.mainImage.alt)" -NoNewline

  $item = [PSCustomObject]@{
    Sku = $product
    Required = $products[$product]
    Description = $productInfo.mainImage.alt
    Price = $productInfo.price
  }
  foreach ($store in $stores.Keys) {
    $storeId = $stores[$store]
    $resultJson = ikea-availability stock --store $storeId $product --reporter json
    $result = $resultJson | ConvertFrom-Json
    $item | Add-Member -MemberType NoteProperty -Name $store -Value $result.availability.stock
    if ($result.availability.stock -gt 0) {
      Write-Host " $store" -ForegroundColor Green -NoNewline
    }
    else {
      Write-Host " $store" -ForegroundColor Red -NoNewline
    }
  }
  Write-Host
  $items += $item
}

$items
