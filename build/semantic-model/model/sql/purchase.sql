SELECT
    customer_id as p_customer_id,
    cast(purchase_date as timestamp) as purchase_date,
    recency as recency_in_days,
    mntwines,
    mntmeatproducts,
    mntfishproducts,
    mntsweetproducts,
    mntgoldprods,
    mntfruits,
    numdealspurchases,
    numwebpurchases,
    numcatalogpurchases,
    numstorepurchases,
    numwebvisitsmonth,
    (numwebpurchases + numcatalogpurchases + numstorepurchases + numstorepurchases) as purchases,
    (mntwines+mntmeatproducts+mntfishproducts+mntsweetproducts+mntgoldprods+mntfruits) as spend
FROM
   public.purchase_data