"""
Example Nautobot Job

This is a sample job to demonstrate the structure for local job development.
You can use this as a template for creating your own custom jobs.
"""

from nautobot.extras.jobs import Job, StringVar, BooleanVar
from nautobot.dcim.models import Device


class ExampleJob(Job):
    """
    Example job that demonstrates basic job structure.
    """
    
    class Meta:
        name = "Example Job"
        description = "A simple example job for demonstration purposes"
        read_only = False
    
    # Job variables
    device_name = StringVar(
        description="Name of the device to process",
        required=True
    )
    dry_run = BooleanVar(
        description="Run in dry-run mode (no changes made)",
        default=True
    )
    
    def run(self, data, commit):
        """
        Main job execution method.
        
        Args:
            data: Dictionary containing the job variables
            commit: Boolean indicating whether to commit changes
        """
        device_name = data["device_name"]
        dry_run = data["dry_run"]
        
        self.log_info(f"Starting example job for device: {device_name}")
        self.log_info(f"Dry run mode: {dry_run}")
        
        try:
            # Try to find the device
            device = Device.objects.get(name=device_name)
            self.log_success(f"Found device: {device.name} ({device.device_type})")
            
            if not dry_run:
                # Perform actual operations here
                self.log_info("Performing operations...")
                # Example: device.save()
                self.log_success("Operations completed successfully!")
            else:
                self.log_info("Dry run mode - no changes made")
                
        except Device.DoesNotExist:
            self.log_warning(f"Device '{device_name}' not found")
        except Exception as e:
            self.log_error(f"Error processing device: {str(e)}")
        
        self.log_info("Example job completed")
