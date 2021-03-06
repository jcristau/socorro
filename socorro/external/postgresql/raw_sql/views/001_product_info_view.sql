CREATE VIEW product_info AS
SELECT product_versions.product_version_id,
       product_versions.product_name,
       product_versions.version_string,
       'new'::text AS which_table,
       product_versions.build_date AS start_date,
       product_versions.sunset_date AS end_date,
       product_versions.featured_version AS is_featured,
       product_versions.build_type,
       ((product_release_channels.throttle * (100)::numeric))::numeric(5,2) AS throttle,
       product_versions.version_sort,
       products.sort AS product_sort,
       release_channels.sort AS channel_sort,
       product_versions.has_builds,
       product_versions.is_rapid_beta
FROM ( ( ( product_versions
          JOIN product_release_channels ON ( ( ( product_versions.product_name = product_release_channels.product_name )
                                              AND ( product_versions.build_type = product_release_channels.release_channel ) ) ) )
        JOIN products ON ( ( product_versions.product_name = products.product_name ) ) )
      JOIN release_channels ON ( ( product_versions.build_type = release_channels.release_channel ) ) )
ORDER BY product_versions.product_name,
         product_versions.version_string;
