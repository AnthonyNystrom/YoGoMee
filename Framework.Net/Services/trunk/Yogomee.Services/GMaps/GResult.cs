/* ------------------------------------------------
 * GResult.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Runtime.Serialization;

namespace Yogomee.Services.GMaps
{
    [DataContract(Namespace = "http://www.yogomee.com/")]
    public class GResult
    {
        [DataMember(Name = "GsearchResultClass")]
        public String ResultClass;
        [DataMember(Name = "viewportmode")]
        public String ViewPortMode;
        [DataMember(Name = "listingType")]
        public String ListingType;
        [DataMember(Name = "lat")]
        public Double Latitude;
        [DataMember(Name = "lng")]
        public Double Longitude;
        [DataMember(Name = "accuracy")]
        public Double Accuracy;
        [DataMember(Name = "title")]
        public String Title;
        [DataMember(Name = "titleNoFormatting")]
        public String TitleNoFormatting;
        [DataMember(Name = "ddUrl")]
        public String DdUrl;
        [DataMember(Name = "ddUrlToHere")]
        public String DdUrlToHere;
        [DataMember(Name = "ddUrlFromHere")]
        public String DdUrlFromHere;
        [DataMember(Name = "streetAddress")]
        public String StreetAddress;
        [DataMember(Name = "city")]
        public String City;
        [DataMember(Name = "region")]
        public String Region;
        [DataMember(Name = "country")]    
        public String Country;
        [DataMember(Name = "staticMapUrl")]
        public String StaticMapUrl;
        [DataMember(Name = "url")]
        public String Url;
        [DataMember(Name = "content")]
        public String Content;
        [DataMember(Name = "phoneNumbers")]
        public GPhoneNumber[] PhoneNumbers;
        [DataMember(Name = "addressLines")]
        public String[] AddressLines;
    }
}
