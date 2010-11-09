<?php
// Make sure SimplePie is included. You may need to change this to match the location of simplepie.inc.
require_once('./php/simplepie.inc');
 
// We'll process this feed with all of the default options.
$feed = new SimplePie('http://blog.7touchgroup.com/feed/');
 
// This makes sure that the content is sent to the browser as text/html and the UTF-8 character set (since we didn't change it).
$feed->handle_content_type();

$feed->init();

$pageTitle = 'privacy policy';

include("header.php");
?>
		<p>
			7touch Group, Inc. obtains all information, downloadable files and software contained herein 
			from sources believed by 7touch Group, Inc. to be accurate and reliable. Because of the 
			possibility of human and mechanical error as well as other factors, 7touch Group, Inc. 
			shall not be held responsible for any errors or omissions in the information, and/or 
			downloadable files, and/or software available at the 7touch Group, Inc. web site. 
			7touch Group, Inc. makes no representations, and expressly disclaims all responsibilities, 
			about the suitability, for any purpose, of the information, downloadable files and/or software 
			that are available to the user at the 7touch Group, Inc. web site. 
		</p>
		<p>
			Information and software may be changed at any time without notice of any kind. The information and software on this site 
			are provided "as is" without expressed or implied warranty of any kind. 7touch Group, Inc. 
			disclaims all warranties with regard to the information and/or software, including all implied 
			warranties of merchantability and fitness for a particular purpose. In no event shall 7touch Group, Inc. 
			be liable for any special, incidental, indirect or consequential damages or any other damages whatsoever, 
			including without limitation, any loss of use, lost data, or lost profits or opportunity, or punitive damages, 
			whether in an action of contract, negligence or other tort action, arising out of or in connection with 
			the accuracy, use, or performance of the information, and/or downloadable files and/or software on 
			7touch Group, Inc.'s web site. 
		</p>
		<p>
			Some U.S. states and foreign countries provide rights in addition to 
			those above, or do not allow limitation or exclusion of implied warranties, or liability for incidental 
			or consequential damages. Therefore, the above limitations may not apply to you or there may be 
			state provisions that supersede the above. Any clause or any portion of a clause declared invalid shall 
			be deemed severable and shall not affect the validity or enforceability of the remainder of the clause. 
			These terms may only be amended in writing, must be signed by 7touch Group, Inc.'s authorized representatives, 
			and shall be governed by the laws of the Mcleod County, Minnesota.
		</p>
		<p>
			YOU EXPRESSLY AGREE THAT USE OF 7touch Group, Inc.'s SITE IS AT YOUR SOLE RISK. 7touch Group, Inc.'s SITE 
			IS PROVIDED ON AN "AS IS" AND "AS AVAILABLE" BASIS. 7touch Group, Inc. EXPRESSLY DISCLAIMS ALL WARRANTIES 
			OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION ANY WARRANTY OF MERCHANTABILITY OR FITNESS 
			FOR A PARTICULAR PURPOSE. 7touch Group, Inc. MAKES NO WARRANTY THAT 7touch Group, Inc.'s SITE WILL MEET 
			YOUR REQUIREMENTS, OR THAT 7touch Group, Inc.'s SITE WILL BE UNINTERRUPTED, TIMELY, SECURE, OR ERROR FREE; 
			NOR DOES 7touch Group, Inc. MAKE ANY WARRANTY AS TO THE RESULTS THAT MAY BE OBTAINED FROM THE USE OF 
			7touch Group, Inc.'s SITE.7touch Group, Inc. WILL NOT BE LIABLE FOR ANY DIRECT, CONSEQUENTIAL OR INCIDENTAL 
			DAMAGES, WHETHER FORESEEABLE OR NOT, WHICH MAY RESULT FROM THE UNAVAILABILITY OR MALFUNCTION OF 
			7touch Group, Inc.'s SITE.
		</p>
		<p>	
			YOU UNDERSTAND AND AGREE THAT ANY MATERIAL AND/OR DATA DOWNLOADED OR OTHERWISE OBTAINED THROUGH THE USE 
			OF 7touch Group, Inc.'s SITE IS AT YOUR OWN DISCRETION AND RISK AND THAT YOU WILL BE SOLELY RESPONSIBLE 
			FOR ANY DAMAGE TO YOUR COMPUTER SYSTEM OR LOSS OF DATA THAT RESULTS FROM THE DOWNLOAD OF SUCH MATERIAL 
			AND/OR DATA. YOU UNDERSTAND AND AGREE THAT 7touch Group, Inc. DOES NOT GUARANTEE THE ACCURACY OR COMPLETENESS 
			OF ANY INFORMATION IN OR PROVIDED IN CONNECTION WITH 7touch Group, Inc.'s SITE. 7touch Group, Inc. IS NOT 
			RESPONSIBLE FOR ANY ERRORS OR OMISSIONS OR FOR THE RESULTS OBTAINED FROM THE USE OF SUCH INFORMATION. 
		</p>
		<p>	
			THE INFORMATION IS PROVIDED WITH THE UNDERSTANDING THAT NEITHER 7touch Group, Inc. NOR ITS MEMBERS, 
			WHILE SUCH MEMBERS ARE PARTICIPATING IN 7touch Group, Inc.'s SITE, ARE ENGAGED IN RENDERING LEGAL, 
			BUSINESS, INVESTING, COUNSELING OR OTHER ADVISORY SERVICES.7touch Group, Inc. ENCOURAGES YOU TO SEEK 
			APPROPRIATE PROFESSIONAL ADVICE OR CARE FOR ANY SITUATION OR PROBLEM THAT YOU MAY HAVE. 
		</p>
		<p>
			7touch Group, Inc. SHALL NOT BE RESPONSIBLE FOR ANY LOSS OR DAMAGE CAUSED, OR ALLEGED TO HAVE BEEN CAUSED, 
			DIRECTLY OR INDIRECTLY, BY THE INFORMATION OR IDEAS CONTAINED, SUGGESTED OR REFERENCED IN THIS SERVICE AREA.
			YOUR PARTICIPATION IN 7touch Group, Inc.'s SITE IS ENTIRELY AT YOUR OWN RISK. NO ADVICE OR INFORMATION, 
			WHETHER ORAL OR WRITTEN, OBTAINED BY YOU FROM 7touch Group, Inc. OR THROUGH 7touch Group, Inc.'s SITE 
			SHALL CREATE ANY WARRANTY NOT EXPRESSLY MADE HEREIN. 7touch Group, Inc. MAKES NO WARRANTY REGARDING ANY 
			GOODS OR SERVICES PURCHASED OR OBTAINED THROUGH 7touch Group, Inc.'s SITE OR ANY TRANSACTIONS ENTERED 
			INTO THROUGH 7touch Group, Inc.'s SITE.7touch Group, Inc. IS NOT RESPONSIBLE FOR THE CONTENT ON THE 
			INTERNET OR WORLD WIDE WEB PAGES THAT IS CONTAINED OUTSIDE 7touch Group, Inc.'s SITE.
		</p>
		<p>	
			AS A CONVENIENCE TO 7touch Group, Inc.'s USERS, 7touch Group, Inc. MAY PROVIDE LINKS TO RESOURCES THAT 
			ARE BEYOND 7touch Group, Inc.'s CONTROL. 7touch Group, Inc. MAKES NO REPRESENTATIONS AS TO THE QUALITY, 
			SUITABILITY, FUNCTIONALITY OR LEGALITY OF ANY SITES TO WHICH 7touch Group, Inc. MAY PROVIDE LINKS, AND 
			YOU HEREBY WAIVE ANY CLAIM YOU MIGHT HAVE AGAINST 7touch Group, Inc. WITH RESPECT TO SUCH SITES.
		</p>
		<p>
			All third-party trademarks within this Site are copyrights of their respective owners and are subject 
			to each mark holder's respective terms of use.
		</p>
<?php
include("footer.php");
?>
