﻿using System;
using System.Collections;
using System.IO;

namespace YGMEUserContactAccessAPI
{
    public class CSVReader : IDisposable
    {

        #region Private variables

        private Stream stream = null;
        private StreamReader reader = null;

        #endregion

        /// <summary>
        /// Create a new reader for the given stream.
        /// </summary>
        /// <param name="s">The stream to read the CSV from.</param>


        /// <summary>
        /// Create a new reader for the given stream and encoding.
        /// </summary>
        /// <param name="s">The stream to read the CSV from.</param>
        /// <param name="enc">The encoding used.</param>


        /// <summary>
        /// Creates a new reader for the given text file path.
        /// </summary>
        /// <param name="filename">The name of the file to be read.</param>

        public CSVReader(StreamReader r)
        {
            reader = r;
        }

        /// <summary>
        /// Creates a new reader for the given text file path and encoding.
        /// </summary>
        /// <param name="filename">The name of the file to be read.</param>
        /// <param name="enc">The encoding used.</param>


        /// <summary>
        /// Returns the fields for the next row of CSV data (or null if at eof)
        /// </summary>
        /// <returns>A string array of fields or null if at the end of file.</returns>
        public string[] GetCSVLine()
        {

            string data = reader.ReadLine();
            if (data == null) return null;
            if (data.Length == 0) return new string[0];

            ArrayList result = new ArrayList();

            ParseCSVFields(result, data);

            return (string[])result.ToArray(typeof(string));
        }

        // Parses the CSV fields and pushes the fields into the result arraylist
        private void ParseCSVFields(ArrayList result, string data)
        {

            int pos = -1;
            while (pos < data.Length)
            {
                string strRes = ParseCSVField(data, ref pos);
                result.Add(strRes);
            }
        }

        // Parses the field at the given position of the data, modified pos to match
        // the first unparsed position and returns the parsed field
        private string ParseCSVField(string data, ref int startSeparatorPosition)
        {

            if (startSeparatorPosition == data.Length - 1)
            {
                startSeparatorPosition++;
                // The last field is empty
                return "";
            }

            int fromPos = startSeparatorPosition + 1;

            // Determine if this is a quoted field
            if (data[fromPos] == '"')
            {
                // If we're at the end of the string, let's consider this a field that
                // only contains the quote
                if (fromPos == data.Length - 1)
                {
                    startSeparatorPosition++;
                    return "\"";
                }

                // Otherwise, return a string of appropriate length with double quotes collapsed
                // Note that FSQ returns data.Length if no single quote was found
                int nextSingleQuote = FindSingleQuote(data, fromPos + 1);
                startSeparatorPosition = nextSingleQuote + 1;
                return data.Substring(fromPos + 1, nextSingleQuote - fromPos - 1).Replace("\"\"", "\"");
            }

            // The field ends in the next comma or EOL
            int nextComma = data.IndexOf(',', fromPos);
            if (nextComma == -1)
            {
                startSeparatorPosition = data.Length;
                return data.Substring(fromPos);
            }
            startSeparatorPosition = nextComma;
            return data.Substring(fromPos, nextComma - fromPos);
        }

        // Returns the index of the next single quote mark in the string 
        // (starting from startFrom)
        private int FindSingleQuote(string data, int startFrom)
        {

            int i = startFrom - 1;
            while (++i < data.Length)
                if (data[i] == '"')
                {
                    // If this is a double quote, bypass the chars
                    if (i < data.Length - 1 && data[i + 1] == '"')
                    {
                        i++;
                        continue;
                    }
                    return i;
                }
            // If no quote found, return the end value of i (data.Length)
            return i;
        }

        /// <summary>
        /// Disposes the CSVReader. The underlying stream is closed.
        /// </summary>
        public void Dispose()
        {
            // Closing the reader closes the underlying stream, too
            if (reader != null) reader.Close();
            else if (stream != null)
                stream.Close(); // In case we failed before the reader was constructed
            GC.SuppressFinalize(this);
        }
    }


    /// <summary>
    /// Exception class for CSVReader exceptions.
    /// </summary>
    public class CSVReaderException : ApplicationException
    {

        /// <summary>
        /// Constructs a new exception object with the given message.
        /// </summary>
        /// <param name="message">The exception message.</param>
        public CSVReaderException(string message) : base(message) { }
    }
}
