select 'THIS SCRIPT SHOULD NOT SELECT ANY ROW' AS 'XWIKI SANITY CHECK';

select 'checking for data with bad characters in document name' AS 'DOCUMENTS';
select XWD_ID, XWD_FULLNAME from xwikidoc where (XWD_NAME like '% ' or XWD_NAME like '%?%' or XWD_NAME like '%+%' or XWD_NAME like '%\%%' or XWD_NAME like '%&%' or XWD_NAME like '%#%'); 

select 'checking for objects where the document does not exist anymore' AS 'OBJECTS';
select * from xwikiobjects where XWO_NAME not in (select XWD_FULLNAME from xwikidoc);  

select 'checking for attachment where the document does not exist' AS 'ATTACHMENTS';
select * from xwikiattachment where XWA_DOC_ID not in (select XWD_ID from xwikidoc); 

select 'checking for attachment_archive where the attachment does not exist anymore' AS 'ATTACHMENTS';
select XWA_ID from xwikiattachment_archive where XWA_ID not in (select XWA_ID from xwikiattachment); 

select 'checking for attachment_content where the attachment does not exist anymore' AS 'ATTACHMENTS';
select XWA_ID from xwikiattachment_content where XWA_ID not in (select XWA_ID from xwikiattachment);

select 'checking for attachment with no attachment archive' AS 'ATTACHMENTS';
select XWA_ID from xwikiattachment where XWA_ID not in (select XWA_ID from xwikiattachment_archive); 

select 'checking for attachment with no attachment content' AS 'ATTACHMENTS';
select XWA_ID from xwikiattachment where XWA_ID not in (select XWA_ID from xwikiattachment_content); 

select 'checking for comments where the object does not exist anymore' AS 'COMMENTS';
select XWC_ID from xwikicomments where XWC_ID not in (select XWO_ID from xwikiobjects); 

select 'checking for preferences where the object does not exist anymore' AS 'PREFERENCES';
select XWP_ID from xwikipreferences where XWP_ID not in (select XWO_ID from xwikiobjects); 

select 'This query should return no value. Returned values are properties left over for deleted objects' AS 'PROPERTIES';
select * from xwikiproperties where xwp_id not in (select xwo_id from xwikiobjects);


select 'Cheching for value existing in xwikistrings not in xwikiobjects' AS 'PROPERTIES - String';
select * from xwikistrings where XWS_ID not in (select XWO_ID from xwikiobjects);
select 'Checking for value existing in xwikistrings not it xwikiproperties' AS 'PROPERTIES - String';
select * from xwikistrings where XWS_ID not in (select XWP_ID from xwikiproperties);
select 'Checking for value in xwikiproperties declared as StringProperty and not in xwikistrings' AS 'PROPERTIES - String';
select * from xwikiproperties where xwp_classtype='com.xpn.xwiki.objects.StringProperty' and XWP_ID not in (select XWS_ID from xwikistrings);


select 'This shows data in large string table that should be in string table' AS 'PROPERTIES - String';
select * from xwikiproperties,xwikilargestrings where xwp_classtype='com.xpn.xwiki.objects.StringProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in integer table that should be in string table' AS 'PROPERTIES - String';
select * from xwikiproperties,xwikiintegers where xwp_classtype='com.xpn.xwiki.objects.StringProperty' and xwp_name=xwi_name and xwp_id=xwi_id;
select 'This shows data in long table that should be in string table' AS 'PROPERTIES - String';
select * from xwikiproperties,xwikilongs where xwp_classtype='com.xpn.xwiki.objects.StringProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in double table that should be in string table' AS 'PROPERTIES - String';
select * from xwikiproperties,xwikidoubles where xwp_classtype='com.xpn.xwiki.objects.StringProperty' and xwp_name=xwd_name and xwp_id=xwd_id;
select 'This shows data in float table that should be in string table' AS 'PROPERTIES - String';
select * from xwikiproperties,xwikifloats where xwp_classtype='com.xpn.xwiki.objects.StringProperty' and xwp_name=xwf_name and xwp_id=xwf_id;
select 'This shows data in lists table that should be in string table' AS 'PROPERTIES - String';
select * from xwikiproperties,xwikilists where xwp_classtype='com.xpn.xwiki.objects.StringProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in lists items table that should be in string table' AS 'PROPERTIES - String';
select * from xwikiproperties,xwikilistitems where xwp_classtype='com.xpn.xwiki.objects.StringProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in dates table that should be in string table' AS 'PROPERTIES - String';
select * from xwikiproperties,xwikidates where xwp_classtype='com.xpn.xwiki.objects.StringProperty' and xwp_name=xws_name and xwp_id=xws_id;


select 'Cheching for value existing in xwikilargestrings not in xwikiobjects' AS 'PROPERTIES - LargeString';
select * from xwikilargestrings where XWL_ID not in (select XWO_ID from xwikiobjects);
select 'Checking for value existing in xwikilargestrings not it xwikiproperties' AS 'PROPERTIES - LargeString';
select * from xwikilargestrings where XWL_ID not in (select XWP_ID from xwikiproperties);
select 'Checking for value in xwikiproperties declared as LargeStringProperty and not in xwikilargestrings' AS 'PROPERTIES - LargeString';
select * from xwikiproperties where xwp_classtype='com.xpn.xwiki.objects.LargeStringProperty' and XWP_ID not in (select XWL_ID from xwikilargestrings);

select 'This shows data in string table that should be in large string table' AS 'PROPERTIES - LargeString';
select * from xwikiproperties,xwikistrings where xwp_classtype='com.xpn.xwiki.objects.LargeStringProperty' and xwp_name=xws_name and xwp_id=xws_id;
select 'This shows data in integer table that should be in large string table' AS 'PROPERTIES - LargeString';
select * from xwikiproperties,xwikiintegers where xwp_classtype='com.xpn.xwiki.objects.LargeStringProperty' and xwp_name=xwi_name and xwp_id=xwi_id;
select 'This shows data in long table that should be in large string table' AS 'PROPERTIES - LargeString';
select * from xwikiproperties,xwikilongs where xwp_classtype='com.xpn.xwiki.objects.LargeStringProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in double table that should be in large string table' AS 'PROPERTIES - LargeString';
select * from xwikiproperties,xwikidoubles where xwp_classtype='com.xpn.xwiki.objects.LargeStringProperty' and xwp_name=xwd_name and xwp_id=xwd_id;
select 'This shows data in float table that should be in large string table' AS 'PROPERTIES - LargeString';
select * from xwikiproperties,xwikifloats where xwp_classtype='com.xpn.xwiki.objects.LargeStringProperty' and xwp_name=xwf_name and xwp_id=xwf_id;
select 'This shows data in lists table that should be in large string table' AS 'PROPERTIES - LargeString';
select * from xwikiproperties,xwikilists where xwp_classtype='com.xpn.xwiki.objects.LargeStringProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in lists items table that should be in large string table' AS 'PROPERTIES - LargeString';
select * from xwikiproperties,xwikilistitems where xwp_classtype='com.xpn.xwiki.objects.LargeStringProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in dates table that should be in large string table' AS 'PROPERTIES - LargeString';
select * from xwikiproperties,xwikidates where xwp_classtype='com.xpn.xwiki.objects.LargeStringProperty' and xwp_name=xws_name and xwp_id=xws_id;

select 'Cheching for value existing in xwikiintegers not in xwikiobjects' AS 'PROPERTIES - Integer';
select * from xwikiintegers where XWI_ID not in (select XWO_ID from xwikiobjects);
select 'Checking for value existing in xwikiintegers not it xwikiproperties' AS 'PROPERTIES - Integer';
select * from xwikiintegers where XWI_ID not in (select XWP_ID from xwikiproperties);
select 'Checking for value in xwikiproperties declared as IntegerProperty and not in xwikiintegers' AS 'PROPERTIES - Integer';
select * from xwikiproperties where xwp_classtype='com.xpn.xwiki.objects.IntegerProperty' and XWP_ID not in (select XWI_ID from xwikiintegers);


select 'This shows data in large string table that should be in integer table' AS 'PROPERTIES - Integer';
select * from xwikiproperties,xwikilargestrings where xwp_classtype='com.xpn.xwiki.objects.IntegerProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in string table that should be in integer table' AS 'PROPERTIES - Integer';
select * from xwikiproperties,xwikistrings where xwp_classtype='com.xpn.xwiki.objects.IntegerProperty' and xwp_name=xws_name and xwp_id=xws_id;
select 'This shows data in long table that should be in integer table' AS 'PROPERTIES - Integer';
select * from xwikiproperties,xwikilongs where xwp_classtype='com.xpn.xwiki.objects.IntegerProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in double table that should be in integer table' AS 'PROPERTIES - Integer';
select * from xwikiproperties,xwikidoubles where xwp_classtype='com.xpn.xwiki.objects.IntegerProperty' and xwp_name=xwd_name and xwp_id=xwd_id;
select 'This shows data in float table that should be in integer table' AS 'PROPERTIES - Integer';
select * from xwikiproperties,xwikifloats where xwp_classtype='com.xpn.xwiki.objects.IntegerProperty' and xwp_name=xwf_name and xwp_id=xwf_id;
select 'This shows data in lists table that should be in integer table' AS 'PROPERTIES - Integer';
select * from xwikiproperties,xwikilists where xwp_classtype='com.xpn.xwiki.objects.IntegerProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in lists items table that should be in integer table' AS 'PROPERTIES - Integer';
select * from xwikiproperties,xwikilistitems where xwp_classtype='com.xpn.xwiki.objects.IntegerProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in dates table that should be in integer table' AS 'PROPERTIES - Integer';
select * from xwikiproperties,xwikidates where xwp_classtype='com.xpn.xwiki.objects.IntegerProperty' and xwp_name=xws_name and xwp_id=xws_id;

select 'Cheching for value existing in xwikilongs not in xwikiobjects' AS 'PROPERTIES - Long';
select * from xwikilongs where XWL_ID not in (select XWO_ID from xwikiobjects);
select 'Checking for value existing in xwikiintegers not it xwikiproperties' AS 'PROPERTIES - Long';
select * from xwikilongs where XWL_ID not in (select XWP_ID from xwikiproperties);
select 'Checking for value in xwikiproperties declared as LongProperty and not in xwikilongs' AS 'PROPERTIES - Long';
select * from xwikiproperties where xwp_classtype='com.xpn.xwiki.objects.LongProperty' and XWP_ID not in (select XWL_ID from xwikilongs);


select 'This shows data in large string table that should be in long table' AS 'PROPERTIES - Long';
select * from xwikiproperties,xwikilargestrings where xwp_classtype='com.xpn.xwiki.objects.LongProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in string table that should be in long table' AS 'PROPERTIES - Long';
select * from xwikiproperties,xwikistrings where xwp_classtype='com.xpn.xwiki.objects.LongProperty' and xwp_name=xws_name and xwp_id=xws_id;
select 'This shows data in integer table that should be in long table' AS 'PROPERTIES - Long';
select * from xwikiproperties,xwikiintegers where xwp_classtype='com.xpn.xwiki.objects.LongProperty' and xwp_name=xwi_name and xwp_id=xwi_id;
select 'This shows data in double table that should be in long table' AS 'PROPERTIES - Long';
select * from xwikiproperties,xwikidoubles where xwp_classtype='com.xpn.xwiki.objects.LongProperty' and xwp_name=xwd_name and xwp_id=xwd_id;
select 'This shows data in float table that should be in long table' AS 'PROPERTIES - Long';
select * from xwikiproperties,xwikifloats where xwp_classtype='com.xpn.xwiki.objects.LongProperty' and xwp_name=xwf_name and xwp_id=xwf_id;
select 'This shows data in lists table that should be in long table' AS 'PROPERTIES - Long';
select * from xwikiproperties,xwikilists where xwp_classtype='com.xpn.xwiki.objects.LongProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in lists items table that should be in long table' AS 'PROPERTIES - Long';
select * from xwikiproperties,xwikilistitems where xwp_classtype='com.xpn.xwiki.objects.LongProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in dates table that should be in long table' AS 'PROPERTIES - Long';
select * from xwikiproperties,xwikidates where xwp_classtype='com.xpn.xwiki.objects.LongProperty' and xwp_name=xws_name and xwp_id=xws_id;

select 'Cheching for value existing in xwikifloats not in xwikiobjects' AS 'PROPERTIES - Float';
select * from xwikifloats where XWF_ID not in (select XWO_ID from xwikiobjects);
select 'Checking for value existing in xwikiintegers not it xwikiproperties' AS 'PROPERTIES - Float'; 
select * from xwikifloats where XWF_ID not in (select XWP_ID from xwikiproperties);
select 'Checking for value in xwikiproperties declared as FloatProperty and not in xwikifloats' AS 'PROPERTIES - Float';
select * from xwikiproperties where xwp_classtype='com.xpn.xwiki.objects.FloatProperty' and XWP_ID not in (select XWF_ID from xwikifloats);

select 'This shows data in large string table that should be in float table' AS 'PROPERTIES - Float';
select * from xwikiproperties,xwikilargestrings where xwp_classtype='com.xpn.xwiki.objects.FloatProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in string table that should be in float table' AS 'PROPERTIES - Float';
select * from xwikiproperties,xwikistrings where xwp_classtype='com.xpn.xwiki.objects.FloatProperty' and xwp_name=xws_name and xwp_id=xws_id;
select 'This shows data in integer table that should be in float table' AS 'PROPERTIES - Float';
select * from xwikiproperties,xwikiintegers where xwp_classtype='com.xpn.xwiki.objects.FloatProperty' and xwp_name=xwi_name and xwp_id=xwi_id;
select 'This shows data in double table that should be in float table' AS 'PROPERTIES - Float';
select * from xwikiproperties,xwikidoubles where xwp_classtype='com.xpn.xwiki.objects.FloatProperty' and xwp_name=xwd_name and xwp_id=xwd_id;
select 'This shows data in long table that should be in float table' AS 'PROPERTIES - Float';
select * from xwikiproperties,xwikilongs where xwp_classtype='com.xpn.xwiki.objects.FloatProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in integer table that should be in float table' AS 'PROPERTIES - Float';
select * from xwikiproperties,xwikiintegers where xwp_classtype='com.xpn.xwiki.objects.FloatProperty' and xwp_name=xwi_name and xwp_id=xwi_id;
select 'This shows data in lists table that should be in float table' AS 'PROPERTIES - Float';
select * from xwikiproperties,xwikilists where xwp_classtype='com.xpn.xwiki.objects.FloatProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in lists items table that should be in float table' AS 'PROPERTIES - Float';
select * from xwikiproperties,xwikilistitems where xwp_classtype='com.xpn.xwiki.objects.FloatProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in dates table that should be in float table' AS 'PROPERTIES - Float';
select * from xwikiproperties,xwikidates where xwp_classtype='com.xpn.xwiki.objects.FloatProperty' and xwp_name=xws_name and xwp_id=xws_id;

select 'Cheching for value existing in xwikidoubles not in xwikiobjects' AS 'PROPERTIES - Double';
select * from xwikidoubles where XWD_ID not in (select XWO_ID from xwikiobjects);
select 'Checking for value existing in xwikidoubles not it xwikiproperties' AS 'PROPERTIES - Double';
select * from xwikidoubles where XWD_ID not in (select XWP_ID from xwikiproperties);
select 'Checking for value in xwikiproperties declared as DoubleProperty and not in xwikidoubles' AS 'PROPERTIES - Double';
select * from xwikiproperties where xwp_classtype='com.xpn.xwiki.objects.DoubleProperty' and XWP_ID not in (select XWD_ID from xwikidoubles);

select 'This shows data in large string table that should be in double table' AS 'PROPERTIES - Double';
select * from xwikiproperties,xwikilargestrings where xwp_classtype='com.xpn.xwiki.objects.DoubleProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in string table that should be in double table' AS 'PROPERTIES - Double';
select * from xwikiproperties,xwikistrings where xwp_classtype='com.xpn.xwiki.objects.DoubleProperty' and xwp_name=xws_name and xwp_id=xws_id;
select 'This shows data in integer table that should be in double table' AS 'PROPERTIES - Double';
select * from xwikiproperties,xwikiintegers where xwp_classtype='com.xpn.xwiki.objects.DoubleProperty' and xwp_name=xwi_name and xwp_id=xwi_id;
select 'This shows data in long table that should be in double table' AS 'PROPERTIES - Double';
select * from xwikiproperties,xwikilongs where xwp_classtype='com.xpn.xwiki.objects.DoubleProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in float table that should be in double table' AS 'PROPERTIES - Double';
select * from xwikiproperties,xwikifloats where xwp_classtype='com.xpn.xwiki.objects.DoubleProperty' and xwp_name=xwf_name and xwp_id=xwf_id;
select 'This shows data in lists table that should be in double table' AS 'PROPERTIES - Double';
select * from xwikiproperties,xwikilists where xwp_classtype='com.xpn.xwiki.objects.DoubleProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in lists items table that should be in double table' AS 'PROPERTIES - Double';
select * from xwikiproperties,xwikilistitems where xwp_classtype='com.xpn.xwiki.objects.DoubleProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in dates table that should be in  double table' AS 'PROPERTIES - Double';
select * from xwikiproperties,xwikidates where xwp_classtype='com.xpn.xwiki.objects.DoubleProperty' and xwp_name=xws_name and xwp_id=xws_id;

select 'Cheching for value existing in xwikilargestrings not in xwikiobjects' AS 'PROPERTIES - StringList';
select * from xwikilargestrings where XWL_ID not in (select XWO_ID from xwikiobjects);
select 'Checking for value existing in xwikilargestrings not it xwikiproperties' AS 'PROPERTIES - StringList';
select * from xwikilargestrings where XWL_ID not in (select XWP_ID from xwikiproperties);
select 'Checking for value in xwikiproperties declared as StringListProperty and not in xwikilargestrings' AS 'PROPERTIES - StringList';
select * from xwikiproperties where xwp_classtype='com.xpn.xwiki.objects.StringListProperty' and XWP_ID not in (select XWL_ID from xwikilargestrings);

select 'This shows data in string table that should be in largestring table' AS 'PROPERTIES - StringList';
select * from xwikiproperties,xwikistrings where xwp_classtype='com.xpn.xwiki.objects.StringListProperty' and xwp_name=xws_name and xwp_id=xws_id;
select 'This shows data in integer table that should be in largestring table' AS 'PROPERTIES - StringList';
select * from xwikiproperties,xwikiintegers where xwp_classtype='com.xpn.xwiki.objects.StringListProperty' and xwp_name=xwi_name and xwp_id=xwi_id;
select 'This shows data in long table that should be in largestring table' AS 'PROPERTIES - StringList';
select * from xwikiproperties,xwikilongs where xwp_classtype='com.xpn.xwiki.objects.StringListProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in double table that should be in largestring table' AS 'PROPERTIES - StringList';
select * from xwikiproperties,xwikidoubles where xwp_classtype='com.xpn.xwiki.objects.StringListProperty' and xwp_name=xwd_name and xwp_id=xwd_id;
select 'This shows data in float table that should be in largestring table' AS 'PROPERTIES - StringList';
select * from xwikiproperties,xwikifloats where xwp_classtype='com.xpn.xwiki.objects.StringListProperty' and xwp_name=xwf_name and xwp_id=xwf_id;
select 'This shows data in lists table that should be in largestring table' AS 'PROPERTIES - StringList';
select * from xwikiproperties,xwikilists where xwp_classtype='com.xpn.xwiki.objects.StringListProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in lists items table that should be in largestring table' AS 'PROPERTIES - StringList';
select * from xwikiproperties,xwikilistitems where xwp_classtype='com.xpn.xwiki.objects.StringListProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in dates table that should be in largestring table' AS 'PROPERTIES - StringList';
select * from xwikiproperties,xwikidates where xwp_classtype='com.xpn.xwiki.objects.StringListProperty' and xwp_name=xws_name and xwp_id=xws_id;


select 'Cheching for value existing in xwikilists not in xwikiobjects' AS 'PROPERTIES - DBStringList';
select * from xwikilists where XWL_ID not in (select XWO_ID from xwikiobjects);
select 'Checking for value existing in xwikilists not it xwikiproperties' AS 'PROPERTIES - DBStringList';
select * from xwikilists where XWL_ID not in (select XWP_ID from xwikiproperties);
select 'Checking for value in xwikiproperties declared as DBStringListProperty and not in xwikilists' AS 'PROPERTIES - DBStringList';
select * from xwikiproperties where xwp_classtype='com.xpn.xwiki.objects.DBStringListProperty' and XWP_ID not in (select XWL_ID from xwikilists);
select 'Checking for value in xwikilistitems and not in xwikilists' AS 'PROPERTIES - DBStringList';
select * from xwikilistitems where XWL_ID not in (select XWL_ID from xwikilists);

select 'This shows data in large string table that should be in list table' AS 'PROPERTIES - DBStringList';
select * from xwikiproperties,xwikilargestrings where xwp_classtype='com.xpn.xwiki.objects.DBStringListProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in string table that should be in list table' AS 'PROPERTIES - DBStringList';
select * from xwikiproperties,xwikistrings where xwp_classtype='com.xpn.xwiki.objects.DBStringListProperty' and xwp_name=xws_name and xwp_id=xws_id;
select 'This shows data in integer table that should be in list table' AS 'PROPERTIES - DBStringList';
select * from xwikiproperties,xwikiintegers where xwp_classtype='com.xpn.xwiki.objects.DBStringListProperty' and xwp_name=xwi_name and xwp_id=xwi_id;
select 'This shows data in long table that should be in list table' AS 'PROPERTIES - DBStringList';
select * from xwikiproperties,xwikilongs where xwp_classtype='com.xpn.xwiki.objects.DBStringListProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in double table that should be in list table' AS 'PROPERTIES - DBStringList';
select * from xwikiproperties,xwikidoubles where xwp_classtype='com.xpn.xwiki.objects.DBStringListProperty' and xwp_name=xwd_name and xwp_id=xwd_id;
select 'This shows data in float table that should be in list table' AS 'PROPERTIES - DBStringList';
select * from xwikiproperties,xwikifloats where xwp_classtype='com.xpn.xwiki.objects.DBStringListProperty' and xwp_name=xwf_name and xwp_id=xwf_id;
select 'This shows data in dates table that should be in  list table' AS 'PROPERTIES - DBStringList';
select * from xwikiproperties,xwikidates where xwp_classtype='com.xpn.xwiki.objects.DBStringListProperty' and xwp_name=xws_name and xwp_id=xws_id;


select 'Cheching for value existing in xwikidates not in xwikiobjects' AS 'PROPERTIES - Date';
select * from xwikidates where XWS_ID not in (select XWO_ID from xwikiobjects);
select 'Checking for value existing in xwikidates not it xwikiproperties' AS 'PROPERTIES - Date';
select * from xwikidates where XWS_ID not in (select XWP_ID from xwikiproperties);
select 'Checking for value in xwikiproperties declared as DateProperty and not in xwikidates' AS 'PROPERTIES - Date';
select * from xwikiproperties where xwp_classtype='com.xpn.xwiki.objects.DateProperty' and XWP_ID not in (select XWS_ID from xwikidates);

select 'This shows data in large string table that should be in date table' AS 'PROPERTIES - Date';
select * from xwikiproperties,xwikilargestrings where xwp_classtype='com.xpn.xwiki.objects.DateProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in string table that should be in date table' AS 'PROPERTIES - Date';
select * from xwikiproperties,xwikistrings where xwp_classtype='com.xpn.xwiki.objects.DateProperty' and xwp_name=xws_name and xwp_id=xws_id;
select 'This shows data in integer table that should be in date table' AS 'PROPERTIES - Date';
select * from xwikiproperties,xwikiintegers where xwp_classtype='com.xpn.xwiki.objects.DateProperty' and xwp_name=xwi_name and xwp_id=xwi_id;
select 'This shows data in long table that should be in date table' AS 'PROPERTIES - Date';
select * from xwikiproperties,xwikilongs where xwp_classtype='com.xpn.xwiki.objects.DateProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in double table that should be in date table' AS 'PROPERTIES - Date';
select * from xwikiproperties,xwikidoubles where xwp_classtype='com.xpn.xwiki.objects.DateProperty' and xwp_name=xwd_name and xwp_id=xwd_id;
select 'This shows data in float table that should be in date table' AS 'PROPERTIES - Date';
select * from xwikiproperties,xwikifloats where xwp_classtype='com.xpn.xwiki.objects.DateProperty' and xwp_name=xwf_name and xwp_id=xwf_id;
select 'This shows data in lists table that should be in date table' AS 'PROPERTIES - Date';
select * from xwikiproperties,xwikilists where xwp_classtype='com.xpn.xwiki.objects.DateProperty' and xwp_name=xwl_name and xwp_id=xwl_id;
select 'This shows data in lists items table that should be in date table' AS 'PROPERTIES - Date';
select * from xwikiproperties,xwikilistitems where xwp_classtype='com.xpn.xwiki.objects.DateProperty' and xwp_name=xwl_name and xwp_id=xwl_id;


select 'Cheking for data in links that does not exist in documents anymore' AS 'LINKS';
select * from xwikilinks where XWL_DOC_ID not in (select XWD_ID from xwikidoc);

select 'Checking original documents that are marked translated' AS 'DOCUMENT - Translations';
select xwd_id, xwd_fullname, xwd_default_language, xwd_language from xwikidoc where (xwd_language = '' OR xwd_language IS NULL) and xwd_translation != 0;
select 'Checking translated documents that are marked original' AS 'DOCUMENT - Translations';
select xwd_id, xwd_fullname, xwd_default_language, xwd_language from xwikidoc where NOT (xwd_language = '' OR xwd_language IS NULL) and xwd_translation = 0;
select 'Checking orphaned translated document (without an original document)' AS 'DOCUMENT - Translations';
select tdoc.xwd_id, tdoc.xwd_fullname, tdoc.xwd_default_language, tdoc.xwd_language from xwikidoc as tdoc left join xwikidoc as doc on doc.xwd_fullname = tdoc.xwd_fullname and tdoc.xwd_id != doc.xwd_id and doc.xwd_translation != 1 where tdoc.xwd_translation = 1 and doc.xwd_translation IS NULL;

select 'Checking similar document with different identifier' AS 'DOCUMENT - Duplicates';
select xwd_fullname, xwd_default_language, xwd_language, count(*) from xwikidoc group by xwd_fullname, xwd_default_language, xwd_language having count(*) > 1;