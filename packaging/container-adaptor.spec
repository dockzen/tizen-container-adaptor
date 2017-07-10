%define debug_package %{nil}

Name:		container-adaptor
Summary:	containerization for Tizen platform
Version:	1.0.0
Release:	0
Group:		System/Configuration
License:	Apache-2.0
BuildArch:	noarch
Source0:	%{name}-%{version}.tar.gz
Source1:	%{name}.manifest
Source2:	%{name}.service

%description
Containerization for Tizen platform

%prep
%setup -q -n %{name}-%{version}
cp %{SOURCE1} ./%{name}.manifest
cp %{SOURCE2} ./%{name}.service

%build

%install
rm -rf %{buildroot}
# Copy shell script to set up network
mkdir -p %{buildroot}/etc
install -m 755 -D script/container_network.sh %{buildroot}/etc/container_network.sh

install -d %{buildroot}/%{_libdir}/systemd/system
cp %{name}.service %{buildroot}/%{_libdir}/systemd/system/%{name}.service

install -d %{buildroot}/%{_libdir}/systemd/system/multi-user.target.wants/
ln -s ../%{name}.service %{buildroot}/%{_libdir}/systemd/system/multi-user.target.wants/

%post
./etc/container_network.sh

%files
%manifest %{name}.manifest
%defattr(-,root,root,-)
%attr(755,root,root) /etc/container_network.sh
%license LICENSE
%attr(644,root,root) %{_libdir}/systemd/system/%{name}.service
%attr(644,root,root) %{_libdir}/systemd/system/multi-user.target.wants/%{name}.service

