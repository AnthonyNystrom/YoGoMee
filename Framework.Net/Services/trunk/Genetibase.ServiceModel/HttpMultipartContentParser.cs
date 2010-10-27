/* ------------------------------------------------
 * HttpMultipartContentParser.cs
 * Copyright © 2008 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Globalization;
using System.IO;
using System.Text;
using System.Text.RegularExpressions;
using Genetibase.ServiceModel.RegularExpressions;

namespace Genetibase.ServiceModel
{
    public static class HttpMultipartContentParser
    {
        private static String GetStreamContentAsString(Stream stream)
        {
            var content = "";
            var buffer = new Byte[65536];
            using (var ms = new MemoryStream())
            {
                while (true)
                {
                    var read = stream.Read(buffer, 0, buffer.Length);
                    if (read <= 0)
                        break;
                    ms.Write(buffer, 0, read);
                }

                content = Encoding.Default.GetString(ms.ToArray());
            }

            return content;
        }

        public static IList<HttpBoundary> GetBoundaries(Stream stream)
        {
            if (stream == null)
                throw new ArgumentNullException("stream");

            var content = GetStreamContentAsString(stream);
            var result = new List<HttpBoundary>();
            var lines = content.Split(new[] { "\r\n" }, StringSplitOptions.None);
            HttpBoundary currentBoundary = null;
            var boundaryIsOpen = false;
            var boundaryIsBinary = false;
            String boundaryStartHeader = null;

            for (var i = 0; i < lines.Length; i++)
            {
                var line = lines[i];

                if (line.StartsWith("--", StringComparison.Ordinal))
                {
                    boundaryStartHeader = line;
                    boundaryIsOpen = true;
                    currentBoundary = new HttpBoundary();
                    result.Add(currentBoundary);
                }
                else if (line.StartsWith("Content-Disposition", StringComparison.OrdinalIgnoreCase))
                {
                    Debug.Assert(currentBoundary != null, "currentBoundary != null");
                    Debug.Assert(boundaryIsOpen == true, "boundaryIsOpen == true");

                    ParseDisposition(currentBoundary, line);
                }
                else if (line.StartsWith("Content-Type", StringComparison.OrdinalIgnoreCase))
                {
                    Debug.Assert(currentBoundary != null, "currentBoundary != null");
                    Debug.Assert(boundaryIsOpen == true, "boundaryIsOpen == true");

                    boundaryIsBinary = ParseContentType(currentBoundary, line);
                }
                else if (line.Length == 0 && i < lines.Length - 1 && boundaryIsOpen)
                {
                    var currentLine = lines[++i];

                    if (boundaryIsBinary)
                    {
                        var valueBuilder = new StringBuilder();
                        Debug.Assert(boundaryStartHeader != null, "boundaryStartHeader != null");
                        var boundaryEndHeader = String.Format(CultureInfo.InvariantCulture, "{0}--", boundaryStartHeader);
                        var notFirstLine = false;
                        while (currentLine != boundaryEndHeader)
                        {
                            if (notFirstLine)
                                valueBuilder.Append("\r\n"); /* We do not use AppendLine since we always need "\r\n" despite the platform. */
                            valueBuilder.Append(currentLine);
                            notFirstLine = true;
                            if (i < lines.Length - 1)
                                currentLine = lines[++i];
                            else
                                break;
                        }
                        currentBoundary.Value = valueBuilder.ToString();
                        boundaryIsBinary = false;
                    }
                    else
                    {
                        currentBoundary.Value = currentLine;
                    }

                    boundaryIsOpen = false;
                }
            }

            return result;
        }

        private static Regex _contentTypeRegex = new ContentTypeRegex();
        private static Boolean ParseContentType(HttpBoundary currentBoundary, String line)
        {
            Debug.Assert(_contentTypeRegex != null, "_contentTypeRegex != null");
            var match = _contentTypeRegex.Match(line);
            if (match != null)
            {
                currentBoundary.ContentType = match.Groups["value"].Value;
                return true;
            }
            return false;
        }

        private static Regex _dispositionRegex = new DispositionRegex();
        private static void ParseDisposition(HttpBoundary currentBoundary, String line)
        {
            Debug.Assert(_dispositionRegex != null, "_dispositionRegex != null");
            var match = _dispositionRegex.Match(line);
            if (match != null)
            {
                var groups = match.Groups;
                currentBoundary.DispositionType = groups["dispositionType"].Value;
                var paramGroup = groups["param"];
                var valueGroup = groups["value"];
                for (var p = 0; p < paramGroup.Captures.Count; p++)
                {
                    currentBoundary.Parameters.Add(
                        new HttpDispositionParameter()
                        {
                            Name = paramGroup.Captures[p].Value,
                            Value = valueGroup.Captures[p].Value
                        });
                }
            }
        }
    }
}
