dataSource {
    pooled = true
    driverClassName = "org.postgresql.Driver"
    dialect = org.hibernate.dialect.PostgreSQLDialect
}
hibernate {
    cache.use_second_level_cache = true
    cache.use_query_cache = true
    cache.provider_class = 'net.sf.ehcache.hibernate.EhCacheProvider'
}
// environment specific settings
environments {
    development {
        dataSource {
            dbCreate = "update"
            url = "jdbc:postgresql://10.0.0.2:5432/vesta"
//            url = "jdbc:postgresql://127.0.0.1:5432/sadweb_nuevo2"
//            url = "jdbc:postgresql://10.0.0.2:5432/sadweb4"
//            url = "jdbc:postgresql://10.0.0.2:5432/happy10"
            username = "postgres"
            password = "postgres"
        }
    }
    test {
        dataSource {
            dbCreate = "update"
            url = "jdbc:postgresql://10.0.0.3:5432/vesta"
            username = "postgres"
            password = "postgres"
        }
    }
    production {
        dataSource {
            dbCreate = "update"
            url = "jdbc:postgresql://127.0.0.1:5432/vesta"
            username = "postgres"
            password = "steinsgate"
        }
    }
}
