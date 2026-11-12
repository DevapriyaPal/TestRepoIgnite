<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
  <html>
  <body>
    <h2>FoCuS Model</h2>
	<xsl:variable name="negativeValues">
		<xsl:for-each select="focus-model">	
			<xsl:value-of select="@negativeValuesEnabled"/>
		</xsl:for-each>
	</xsl:variable>
	
		
    <table border="0">
      <tr bgcolor="#9acd32">
        <th>Attribute</th>
        <th>Value</th>
        <th>Description</th>
		<xsl:if test="$negativeValues='true'"> 
			<th>Negative Value</th>
		</xsl:if>
      </tr>
      <xsl:for-each select="focus-model/attribute">
		<xsl:if test="@type!='COUNTER'">
			<tr bgcolor="#FBF5E6">
			  <td><xsl:value-of select="@name"/></td>
			  <td></td>
			  <td><xsl:value-of select="@description"/></td>
			  <xsl:if test="$negativeValues='true'"> 
					<td></td>
			  </xsl:if>
			</tr>
			<xsl:for-each select="value">
			  <tr>
				<td></td>
				<td><xsl:value-of select="@name"/></td>
				<td>&#x0020;<xsl:value-of select="@description"/></td>
				<xsl:if test="$negativeValues='true'"> 
					<xsl:if test="@negative_value='true'">
						<td>Negative</td>
					</xsl:if>
				</xsl:if>
			  </tr>
			</xsl:for-each>
		</xsl:if>
      </xsl:for-each>
    </table>

	<!-- build a variable 'hasCounter' that is empty iff there are no counters -->
	<xsl:variable name="hasCounters">
		<xsl:for-each select="focus-model/attribute">
			<xsl:if test="@type='COUNTER'">
				Y
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	<!-- If counters exist, add a section and table for them -->
	<xsl:if test="$hasCounters != ''">
		<h2>Counters</h2>
		<table border="0">
		  <tr bgcolor="#9acd32">
			<th>Attribute</th>
			<th>Description</th>
			<th>Counted Attribute</th>
			<th>Counted Value</th>
		  </tr>
		  <xsl:for-each select="focus-model/attribute">
			<xsl:if test="@type='COUNTER'">
				<tr bgcolor="#FBF5E6">
				  <td><xsl:value-of select="@name"/></td>
				  <td><xsl:value-of select="@description"/></td>
				  <td></td>
				  <td></td>
				</tr>
				<xsl:for-each select="countedValue">
					<tr>
						<td></td>
						<td></td>
						<td>
							<xsl:choose>
								<xsl:when test="@attribute">
									<xsl:value-of select="@attribute"/>
								</xsl:when>
								<xsl:otherwise>
									&lt; Any Attribute &gt;
								</xsl:otherwise>
							</xsl:choose>
						</td>
						<td><xsl:value-of select="@value"/></td>
					</tr>
				</xsl:for-each>
			</xsl:if>
		  </xsl:for-each>
		</table>
	</xsl:if>
	
	<!-- build a variable 'hasInactiveRest' that is empty iff there are no inactive restrictions... -->
	<xsl:variable name="hasInactiveRest">
		<xsl:for-each select="focus-model/restriction">
			<xsl:if test="@isActive='false'">
				Y
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
    <h2>Restrictions</h2>
    <table border="1">
      <tr bgcolor="#9acd32">
        <th>Index</th>
        <th>Name</th>
        <th>Type</th>
        <th>Expression</th>
		<xsl:if test="$hasInactiveRest != ''"> 
			<th>Active</th>
		</xsl:if>
      </tr>
      <xsl:for-each select="focus-model/restriction">
        <tr>
          <td><xsl:value-of select="position()"/></td>
          <td>&#160;<xsl:value-of select="@name"/></td>
          <xsl:if test="@type='Exclusion'">
		      <td><xsl:value-of select="@type"/></td>
		  </xsl:if>
          <xsl:if test="@type='Auto-Exclusion'">
		      <td><xsl:value-of select="@type"/></td>
		  </xsl:if>
	  	  <xsl:if test="@type='If-Then'">
	  	  	<xsl:if test="@iff='true'">
	  	  	  <td>If and Only If</td>
	  	  	</xsl:if>
	  	  	<xsl:if test="@iff='false'">
	  	  	  <td>If-Then</td>
	  	  	</xsl:if>	
	  	  </xsl:if>
	  	  <xsl:if test="@type='NotAllowed'">
		      <td>Exclusion</td>
		  </xsl:if>
		  <xsl:if test="@type='Allowed'">
		      <td>Exclusion</td>
		  </xsl:if>
	  	  		    	  		  
	  	  <xsl:if test="@type='Exclusion'">
		      <td><xsl:value-of select="@expression"/></td>
	  	  </xsl:if>
  	  	  <xsl:if test="@type='Auto-Exclusion'">
		      <td><xsl:value-of select="@expression"/></td>
	  	  </xsl:if>
	  	  <xsl:if test="@type='NotAllowed'">
		      <td><xsl:value-of select="@expression"/></td>
	  	  </xsl:if>
	  	  <xsl:if test="@type='Allowed'">
		      <td>!(<xsl:value-of select="@expression"/>)</td>
	  	  </xsl:if>
	  	  <xsl:if test="@type='If-Then'">

 	        <xsl:variable name="iff">
			   <xsl:value-of select="@iff"/>
	        </xsl:variable>		

            <xsl:variable name="apos" select='"&apos;"'/>
            <xsl:variable name="doesntequal" select="concat('Doesn', $apos, 't Equal')"/>   
               
		    <td style="white-space: nowrap;">
		    <xsl:for-each select="if-expr">

  	           <xsl:variable name="if_is_or">
			      <xsl:value-of select="@is_or"/>
	           </xsl:variable>		       

			   <xsl:for-each select="focus-ctd-cond">
                  
                  <!--    The unreadable formatting is intentional to avoid redundant spaces  -->
			      <xsl:if test="position() = 1">&#40;</xsl:if><xsl:value-of select="@attribute"/>&#160;
			        <xsl:choose>
        				<xsl:when test="@operation='Equals'">==</xsl:when>
        				<xsl:when test="@operation=$doesntequal">!=</xsl:when>
        				<xsl:otherwise><xsl:value-of select="@operation"/></xsl:otherwise>
      			    </xsl:choose>
      			  &#160;<xsl:for-each select="focus-ctd-cond-val">
			          <xsl:value-of select="@value"/>
			          <xsl:if test="position() != last()">&#44;</xsl:if>
			      </xsl:for-each>
		          <xsl:if test="position() = last()">&#41;</xsl:if>
		          <xsl:if test="position() != last()">
		          <xsl:if test="$if_is_or='true'">&#160;<font color="brown">&#79;&#82;</font>&#160;</xsl:if>
		          <xsl:if test="$if_is_or!='true'">&#160;<font color="brown">&#65;&#78;&#68;</font>&#160;</xsl:if></xsl:if>
			   </xsl:for-each>
		    </xsl:for-each> 

		   	<xsl:for-each select="then-expr">
				<xsl:if test="$iff='true'">
				   <font color="green" size="6" >&#160;&#8596;&#160;</font>
				</xsl:if>
		   	   	<xsl:if test="$iff='false'">
				   <font color="green" size="6" >&#160;&#8594;&#160;</font>
				</xsl:if>
				
	           <xsl:variable name="then_is_or">
			      <xsl:value-of select="@is_or"/>
	           </xsl:variable>	

			   <xsl:for-each select="focus-ctd-cond">

                  <!--    The unreadable formatting is intentional to avoid redundant spaces  -->
			      <xsl:if test="position() = 1">&#40;</xsl:if><xsl:value-of select="@attribute"/>&#160;
 		          <xsl:choose>
        			<xsl:when test="@operation='Equals'">==</xsl:when>
        			<xsl:when test="@operation=$doesntequal">!=</xsl:when>
        			<xsl:otherwise><xsl:value-of select="@operation"/></xsl:otherwise>
      			  </xsl:choose>
			      &#160;<xsl:for-each select="focus-ctd-cond-val">
			          <xsl:value-of select="@value"/>
			          <xsl:if test="position() != last()">&#44;</xsl:if>
			      </xsl:for-each>
		          <xsl:if test="position() = last()">&#41;</xsl:if>
		          <xsl:if test="position() != last()">
		          <xsl:if test="$then_is_or='true'">&#160;<font color="brown">&#79;&#82;</font>&#160;</xsl:if>
		          <xsl:if test="$then_is_or!='true'">&#160;<font color="brown">&#65;&#78;&#68;</font>&#160;</xsl:if></xsl:if>
			   </xsl:for-each>
		    </xsl:for-each> 
		    </td>
	  	  </xsl:if>

		<xsl:if test="$hasInactiveRest != ''"> 
			<xsl:if test="@isActive='false'">
		      <td>No</td>
			</xsl:if>
			<xsl:if test="@isActive='true'">
		      <td>Yes</td>
			</xsl:if>
		</xsl:if>
        </tr>
      </xsl:for-each>
    </table>

   <h2>Negative Combinations</h2>
      <table border="0">
      <tr bgcolor="#9acd32">
	  <th> Attribute </th>
	  <th> Value </th>
      </tr>
	  
	  <xsl:for-each select="focus-model/negative-combination">
		<xsl:variable name="bgColor">
			<xsl:choose>
				<xsl:when test="position() mod 2 = 1">
					<xsl:text>#FBF5E6</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					"white"
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

        <tr class="odd" style="background-color: {$bgColor};">
          <xsl:for-each select="attr-value">
			 <td> <xsl:value-of select="@attribute"/></td>
			 <td> <xsl:value-of select="@value"/></td>
			  <xsl:if test="position() != last()">
      <xsl:text>;&#160;</xsl:text>
   </xsl:if>
          </xsl:for-each>
	     </tr>
     </xsl:for-each>
    </table>
    
    <h2>Test Descriptions</h2>
      <table border="0">
      <tr bgcolor="#9acd32">
        <th>Trigger Name</th>
        <th>Appliance</th>
        <th>Trigger Type</th>
        <th>Condition</th>
      </tr>

	  <xsl:for-each select="focus-model/focus-ctd-decoration/focus-ctd-trigger">
	  
		<xsl:variable name="bgColor">
			<xsl:choose>
				<xsl:when test="position() mod 2 = 1">
					<xsl:text>#FBF5E6</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					"white"
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

        <tr class="odd" style="background-color: {$bgColor};">
		    <td><xsl:value-of select="@name"/></td>
		    <td><xsl:value-of select="@appliance"/></td>
		    <td>
		    <xsl:if test="@negative='false'">
		       &#65;&#78;&#68;
	  	    </xsl:if>
		    <xsl:if test="@negative='true'">
		       &#79;&#82;
		    </xsl:if>
		    </td>
		    <td style="white-space: nowrap;">
			   <xsl:for-each select="focus-ctd-cond">
               
                 <xsl:variable name="apos" select='"&apos;"'/>
                 <xsl:variable name="doesntequal" select="concat('Doesn', $apos, 't Equal')"/>   
               
                  <!--    The unreadable formatting is intentional to avoid redundant spaces  -->
			      <xsl:value-of select="@attribute"/>&#160;
			      <xsl:choose>
        			<xsl:when test="@operation='Equals'">==</xsl:when>
        			<xsl:when test="@operation=$doesntequal">!=</xsl:when>
        			<xsl:otherwise><xsl:value-of select="@operation"/></xsl:otherwise>
      			  </xsl:choose>
      			  &#160;<xsl:for-each select="focus-ctd-cond-val">
			          <xsl:value-of select="@value"/>
			          <xsl:if test="position() != last()">&#44;
                      </xsl:if>
			      </xsl:for-each>
		          <br/>
			   </xsl:for-each>
		    </td>
		    <xsl:for-each select="focus-ctd-template">
			   <td><xsl:value-of select="@text"/></td>
		    </xsl:for-each>
	     </tr>
      </xsl:for-each>
      
      <xsl:for-each select="focus-model/focus-ctd-decoration/focus-ctd-free-trigger">
	  
		<xsl:variable name="bgColor">
			<xsl:choose>
				<xsl:when test="position() mod 2 = 1">
					<xsl:text>#FBF5E6</xsl:text>
				</xsl:when>
				<xsl:otherwise>
					"white"
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

        <tr class="odd" style="background-color: {$bgColor};">
		    <td><xsl:value-of select="@name"/></td>
		    <td><xsl:value-of select="@appliance"/></td>
		    <td>General Boolean Expression</td>
		    <td><xsl:value-of select="@expression"/></td>
		    <xsl:for-each select="focus-ctd-template">
			   <td><xsl:value-of select="@text"/></td>
		    </xsl:for-each>
	     </tr>
      </xsl:for-each>
    </table>
	
  </body>
  </html>
</xsl:template>

</xsl:stylesheet>