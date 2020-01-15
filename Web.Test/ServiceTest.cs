using System;
using Web.Services;
using Xunit;

namespace Web.Test
{
    public class ServiceTest
    {
        [Fact]
        public void ServiceWorks()
        {
            var sut = new Service();
            var actual = sut.DoThing();
            Assert.Equal("Thing done!", actual);
        }
    }
}
