# Prerequisite: Install ikea-availability-checker NPM package
# https://www.npmjs.com/package/ikea-availability-checker

# Hashtable of product SKUs and # required for your project.
$products = [ordered]@{
  '10467936' = 1  # AXSTAD matte blue 30x10 drawer front
  '00466107' = 1  # AXSTAD dark gray 30x10 drawer front
  '00467908' = 4  # AXSTAD matte blue 15x40 door
  '90466080' = 4  # AXSTAD dark gray 15x40 door
  '30475247' = 2  # AXSTAD matte blue deco strip
  '50334925' = 2  # KUNGSFORS stainless shelf
  '80334919' = 2  # KUNGSFORS wall rack
}

# Hashtable of store names and IDs. You can find these by running a whole-country
# search for a product using ikea-availability-checker, e.g.:
# ikea-availability stock --country us 30265386
$stores = [ordered]@{
  'Woodbridge'  = 168
  'Norfolk'     = 569
  'CollegePark' = 411
  'Baltimore'   = 152
}

$items = @()

foreach ($product in $products.Keys) {
  $folder = $product.Substring(5)
  $productUrl = "https://www.ikea.com/us/en/products/$folder/$product.json"
  $productInfo = Invoke-RestMethod -Uri $productUrl -Method Get
  Write-Host "$product - $($productInfo.mainImage.alt)" -NoNewline

  $item = [PSCustomObject]@{
    Sku         = $product
    Required    = $products[$product]
    Description = $productInfo.mainImage.alt
    Price       = $productInfo.price
  }
  foreach ($store in $stores.Keys) {
    $storeId = $stores[$store]
    $resultJson = ikea-availability stock --store $storeId $product --reporter json
    $result = $resultJson | ConvertFrom-Json
    $item | Add-Member -MemberType NoteProperty -Name $store -Value $result.availability.stock
    if ($result.availability.stock -ge $products[$product]) {
      Write-Host " $store" -ForegroundColor Green -NoNewline
    }
    elseif ($result.availability.stock -gt 0) {
      Write-Host " $store" -ForegroundColor Yellow -NoNewline
    }
    else {
      Write-Host " $store" -ForegroundColor Red -NoNewline
    }
  }
  Write-Host
  $items += $item
}

$items
