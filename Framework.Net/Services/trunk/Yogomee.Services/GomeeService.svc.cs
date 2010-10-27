/* ------------------------------------------------
 * GomeeService.svc.cs
 * Copyright © 2009 Alex Nesterov
 * mailto:a.nesterov@genetibase.com
 * ---------------------------------------------- */

using System;
using System.Net;
using System.Runtime.Serialization.Json;
using System.Web;
using System.Linq;
using Genetibase.ServiceModel;
using Yogomee.Services.GMaps;
using Yogomee.Services.Properties;
using Yogomee.Services.Responses;
using Yogomee.Services.Storage;
using System.Globalization;
using Yogomee.Services.DomainModel;
using Yogomee.Services.DomainModel.Factories;

namespace Yogomee.Services
{
    public class GomeeService : IGomeeService
    {
        private IServiceContext _serviceContext;

        public GomeeService()
        {
            _serviceContext = new ServiceContext();
        }

        public GResponse GMapsSearch(String query)
        {
            _serviceContext.ContentType = "text/html";

            if (String.IsNullOrEmpty(query))
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "query",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.ArgumentNull_String,
                            "query"),
                        Value = query
                    });

            var request = WebRequest.Create(
                    String.Format("http://ajax.googleapis.com/ajax/services/search/local?v=1.0&q={0}", HttpUtility.UrlEncode(query))
                ) as HttpWebRequest;

            GResponse gResponse;

            using (var webResponse = request.GetResponse() as HttpWebResponse)
            {
                var serializer = new DataContractJsonSerializer(typeof(GResponse));
                gResponse = serializer.ReadObject(webResponse.GetResponseStream()) as GResponse;
            }

            return gResponse;
        }

        public GomeesResponse GetMineGomees(Int32 memberId, Int32 firstIndex, Int32 lastIndex)
        {
            _serviceContext.ContentType = "text/html";

            if (firstIndex < 0)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "firstIndex",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.IndexLessThan_String,
                            "firstIndex",
                            0),
                        Value = firstIndex.ToString(CultureInfo.InvariantCulture)
                    });

            if (lastIndex < 0)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "lastIndex",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.IndexLessThan_String,
                            "lastIndex",
                            0),
                        Value = lastIndex.ToString(CultureInfo.InvariantCulture)
                    });

            if (lastIndex < firstIndex)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "lastIndex",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.IndexLessThan_String,
                            "lastIndex",
                            "firstIndex"),
                        Value = lastIndex.ToString(CultureInfo.InvariantCulture)
                    });

            GomeesResponse response = new GomeesResponse();
            IUnitOfWork uow = null;

            try
            {
                uow = new UnitOfWork();
                var member = uow.MemberRepository.Get(memberId);

                var mineGomees = uow.GomeeRepository.GetMineFor(member);
                var gomees = mineGomees
                    .Skip(firstIndex)
                    .Take(lastIndex - firstIndex + 1)
                    .Select(g =>
                    {
                        return new GomeeResponse()
                        {
                            Id = g.Id,
                            MemberId = g.Member.Id,
                            Caption = g.Caption,
                            Address = g.Address,
                            Description = g.Description,
                            Latitude = g.Latitude,
                            Longitude = g.Longitude,
                            Type = g.GomeeType
                        };
                    });

                response.AllCount = mineGomees.Count();
                response.ResponseCount = gomees.Count();
                response.FirstIndex = firstIndex;
                response.Gomees = gomees.ToArray();
            }
            catch (ArgumentException)
            {
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "memberId",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.EntityNotExist_String,
                            "Member"),
                        Value = memberId.ToString(CultureInfo.InvariantCulture)
                    });
            }
            finally
            {
                if (uow != null)
                {
                    uow.Close();
                }
            }

            return response;
        }

        public GomeesResponse GetTheirsGomees(Int32 memberId, Int32 firstIndex, Int32 lastIndex)
        {
            _serviceContext.ContentType = "text/html";

            if (firstIndex < 0)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "firstIndex",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.IndexLessThan_String,
                            "firstIndex",
                            0),
                        Value = firstIndex.ToString(CultureInfo.InvariantCulture)
                    });

            if (lastIndex < 0)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "lastIndex",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.IndexLessThan_String,
                            "lastIndex",
                            0),
                        Value = lastIndex.ToString(CultureInfo.InvariantCulture)
                    });

            if (lastIndex < firstIndex)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "lastIndex",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.IndexLessThan_String,
                            "lastIndex",
                            "firstIndex"),
                        Value = lastIndex.ToString(CultureInfo.InvariantCulture)
                    });

            GomeesResponse response = new GomeesResponse();
            IUnitOfWork uow = null;

            try
            {
                uow = new UnitOfWork();
                var member = uow.MemberRepository.Get(memberId);

                var theirsGomees = uow.GomeeRepository.GetTheirsFor(member);
                var gomees = theirsGomees
                    .Skip(firstIndex)
                    .Take(lastIndex - firstIndex + 1)
                    .Select(g =>
                    {
                        return new GomeeResponse()
                        {
                            Id = g.Id,
                            MemberId = g.Member.Id,
                            Caption = g.Caption,
                            Address = g.Address,
                            Description = g.Description,
                            Latitude = g.Latitude,
                            Longitude = g.Longitude,
                            Type = g.GomeeType
                        };
                    });

                response.AllCount = theirsGomees.Count();
                response.ResponseCount = gomees.Count();
                response.FirstIndex = firstIndex;
                response.Gomees = gomees.ToArray();
            }
            catch (ArgumentException)
            {
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "memberId",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.EntityNotExist_String,
                            "Member"),
                        Value = memberId.ToString(CultureInfo.InvariantCulture)
                    });
            }
            finally
            {
                if (uow != null)
                {
                    uow.Close();
                }
            }

            return response;
        }

        public GomeeResponse AddGomee(
            Int32 memberId,
            String caption,
            String address,
            String description,
            Double latitude,
            Double longitude, Int32 type)
        {
            _serviceContext.ContentType = "text/html";

            if (caption == null)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "caption",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.ArgumentNull_String,
                            "caption"),
                        Value = caption
                    });

            if (address == null)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "address",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.ArgumentNull_String,
                            "address"),
                        Value = address
                    });

            if (description == null)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "description",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.ArgumentNull_String,
                            "description"),
                        Value = description
                    });

            GomeeResponse response = new GomeeResponse();
            IUnitOfWork uow = null;
            IGomeeFactory factory = null;

            try
            {
                uow = new UnitOfWork();
                factory = new GomeeFactory();

                var member = uow.MemberRepository.Get(memberId);
                var gomee = factory.CreateGomee(member);
                gomee.Caption = caption;
                gomee.Address = address;
                gomee.Description = description;
                gomee.Latitude = latitude;
                gomee.Longitude = longitude;
                gomee.GomeeType = type;

                uow.GomeeRepository.Add(gomee);
                uow.PersistAll();

                response.Id = gomee.Id;
                response.MemberId = gomee.Member.Id;
                response.Caption = gomee.Caption;
                response.Address = gomee.Address;
                response.Description = gomee.Description;
                response.Latitude = gomee.Latitude;
                response.Longitude = gomee.Longitude;
                response.Type = gomee.GomeeType;
            }
            catch (ArgumentException)
            {
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "memberId",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.EntityNotExist_String,
                            "Member"),
                        Value = memberId.ToString(CultureInfo.InvariantCulture)
                    });
            }
            finally
            {
                if (uow != null)
                {
                    uow.Close();
                }
            }

            return response;
        }

        public void RemoveGomee(Int32 memberId, Int32 gomeeId)
        {
            _serviceContext.ContentType = "text/html";

            IUnitOfWork uow = null;

            try
            {
                uow = new UnitOfWork();

                var member = uow.MemberRepository.Get(memberId);
                var gomees = uow.GomeeRepository.GetMineFor(member);

                if (gomees.Where(g => g.Id == gomeeId).Count() == 0)
                    throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "gomeeId",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.EntityNotExist_String,
                            "Gomee"),
                        Value = gomeeId.ToString(CultureInfo.InvariantCulture)
                    });

                var gomee = gomees.Where(g => g.Id == gomeeId).Single();

                var targets = uow.TargetRepository.GetFor(gomee);
                foreach (var target in targets)
                {
                    uow.TargetRepository.Remove(target);
                }

                uow.GomeeRepository.Remove(gomee);
                uow.PersistAll();
            }
            catch (ArgumentException)
            {
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "memberId",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.EntityNotExist_String,
                            "Member"),
                        Value = memberId.ToString(CultureInfo.InvariantCulture)
                    });
            }
            finally
            {
                if (uow != null)
                {
                    uow.Close();
                }
            }
        }

        public GomeeResponse SaveGomee(
            Int32 gomeeId,
            String caption,
            String address,
            String description,
            Double latitude,
            Double longitude,
            Int32 type)
        {
            _serviceContext.ContentType = "text/html";

            if (caption == null)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "caption",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.ArgumentNull_String,
                            "caption"),
                        Value = caption
                    });

            if (address == null)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "address",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.ArgumentNull_String,
                            "address"),
                        Value = address
                    });

            if (description == null)
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "description",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.ArgumentNull_String,
                            "description"),
                        Value = description
                    });

            GomeeResponse response = new GomeeResponse();
            IUnitOfWork uow = null;
            
            try
            {
                uow = new UnitOfWork();

                var gomee = uow.GomeeRepository.Get(gomeeId);
                gomee.Caption = caption;
                gomee.Address = address;
                gomee.Description = description;
                gomee.Latitude = latitude;
                gomee.Longitude = longitude;
                gomee.GomeeType = type;

                uow.PersistAll();

                response.Id = gomee.Id;
                response.MemberId = gomee.Member.Id;
                response.Caption = gomee.Caption;
                response.Address = gomee.Address;
                response.Description = gomee.Description;
                response.Latitude = gomee.Latitude;
                response.Longitude = gomee.Longitude;
                response.Type = gomee.GomeeType;
            }
            catch (ArgumentException)
            {
                throw FaultFactory.CreateFaultException(
                    new ArgumentFault()
                    {
                        Argument = "gomeeId",
                        Message = String.Format(
                            CultureInfo.InvariantCulture,
                            Resources.EntityNotExist_String,
                            "Gomee"),
                        Value = gomeeId.ToString(CultureInfo.InvariantCulture)
                    });
            }
            finally
            {
                if (uow != null)
                {
                    uow.Close();
                }
            }

            return response;
        }
    }
}
