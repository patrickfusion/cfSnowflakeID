component {

    this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );
    this.mappings[ "/cfSnowflakeID" ] = expandPath( "/" );
    this.mappings[ "/testbox" ] = this.mappings[ "/cfSnowflakeID" ] & "/testbox";

}
