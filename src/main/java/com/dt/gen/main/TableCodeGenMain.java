package com.dt.gen.main;

import com.dt.gen.conf.PackageConfigBuilder;
import com.dt.gen.conf.ProcessTestPackageConfigBuilder;
import com.dt.gen.service.CodeGenService;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class TableCodeGenMain {

    public static void main(String[] args) {

        PackageConfigBuilder builder = new ProcessTestPackageConfigBuilder();
        String tableNames = "meta01_database_connection";

        log.info("table names: {}", tableNames);
        new CodeGenService("/template/").execute(
                builder.buildPackageConfig(),
                builder.buildDataSourceConfig(),
                tableNames);
    }


}